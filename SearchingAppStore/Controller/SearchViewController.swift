//
//  SearchViewController.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var searchListTableView: SearchListTableView!
    @IBOutlet weak var histoyTableView: SearchHistoryTableView!
    
    @IBOutlet var indicator: UIActivityIndicatorView!
     
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "App Store"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBind()
    }
    
    func setupBind() {
        //최근 검색어 - 전체
        viewModel.allHistorySubject.asObservable().subscribe {
            print("allHistorySubject = ", $0)
            self.histoyTableView.setData(strArr: $0.element ?? [], initial: false)
        }.disposed(by: disposeBag)
        
        //search bar에서 검색했을때
        viewModel.sortHistorySubject.asObservable().subscribe {
            print("sortHistorySubject = ", $0)
            self.histoyTableView.setData(searchText: self.searchController.searchBar.text ?? "", strArr: $0.element ?? [])
        }.disposed(by: disposeBag)
        
        //검색결과는 이쪽으로 온다.
        viewModel.requestResult.observeOn(MainScheduler.instance).subscribe {
            if let error = $0.error {
                print("requestResult = ", error)
            } else {
                self.searchListTableView.isHidden = false
                self.dataLoadingVisible(isLoading: false)
                self.searchListTableView.setData(appInfoArr: $0.element ?? [])
            }
        }.disposed(by: disposeBag)
         
        searchController.searchBar.rx.searchButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: {
            if let text = self.searchController.searchBar.text {
                self.viewModel.saveData(text: text)
                self.viewModel.loadData()
                
                self.dataLoadingVisible(isLoading: true)
                self.viewModel.searchUrl(text: text, page: 0, inheritance: false)
            }
            
            self.searchController.isActive = false
        }).disposed(by: disposeBag)
         
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: {
            print("searchBar.rx.text: \($0)")
            self.searchListTableView.isHidden = true
            if $0 == "" {
                self.histoyTableView.setData(strArr: self.viewModel.allHistorySubject.value, initial: false)
            } else {
                self.viewModel.initialSort(text: $0)
            }
        }).disposed(by: disposeBag)
         
        viewModel.loadData()
    }
    
    func setupUI() {
        searchListTableView.isHidden = true
        searchListTableView.searchListTableViewDelegate = self
        
        histoyTableView.historyTableViewDelegate = self
        
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func dataLoadingVisible(isLoading: Bool) {
        if isLoading {
            self.indicator.startAnimating()
        } else {
            self.indicator.stopAnimating()
        }
    }
}

extension SearchViewController: SearchHistoryTableViewDelegate, SearchListTableViewDelegate {
    func detailSelect(appInfo: AppInfo) {
        print("detailSelect = ", appInfo)
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController {
            vc.appInfo = appInfo
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func dataMoreLoad(page: Int) {
//        if let searchText = self.searchController.searchBar.text {
//            print("dataMoreLoad = ", page)
//            viewModel.searchUrl(text: searchText, page: page, inheritance: true)
//        }
//    }
    
    func select(title: String) {
        print("title = ", title)
        self.searchController.searchBar.text = title
        dataLoadingVisible(isLoading: true)
        viewModel.searchUrl(text: title, page: 0, inheritance: false)
    }
}
 
