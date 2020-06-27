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
    
    enum ViewingList: Int {
        case History = 0
        case AppList = 1
    }
     
    @IBOutlet weak var contentView: UIView!
    var searchListTableView: SearchListTableView?
    var histoyTableView: SearchHistoryTableView?

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
            self.histoyTableView?.setData(strArr: $0.element ?? [], initial: false)
        }.disposed(by: disposeBag)
        
        //search bar에서 검색했을때
        viewModel.sortHistorySubject.asObservable().subscribe {
            print("sortHistorySubject = ", $0)
            self.histoyTableView?.setData(searchText: self.searchController.searchBar.text ?? "", strArr: $0.element ?? [])
        }.disposed(by: disposeBag)
        
        //검색결과는 이쪽으로 온다.
        viewModel.requestResult.observeOn(MainScheduler.asyncInstance).subscribe {
            if let error = $0.error {
                print("requestResult = ", error)
            } else {
                self.listShowing(index: ViewingList.AppList.rawValue)
                self.dataLoadingVisible(isLoading: false)
                self.searchListTableView?.setData(appInfoArr: $0.element ?? [])
            }
        }.disposed(by: disposeBag)
         
        searchController.searchBar.rx.searchButtonClicked.observeOn(MainScheduler.asyncInstance).asDriver(onErrorJustReturn: ()).drive(onNext: {
            if let text = self.searchController.searchBar.text {
                self.viewModel.saveData(text: text)
                self.viewModel.loadData()
                
                self.listShowing(index: 100)
                self.dataLoadingVisible(isLoading: true)
                self.viewModel.searchUrl(text: text, page: 0, inheritance: false)
            }
//            self.searchController.isActive = false
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: {
            self.listShowing(index: ViewingList.History.rawValue)
            if let histoyTableView = self.histoyTableView {
                histoyTableView.setData(strArr: self.viewModel.allHistorySubject.value, initial: false)
            }
            self.dataLoadingVisible(isLoading: false)
        }).disposed(by: disposeBag)
         
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: {
            print("searchBar.rx.text: \($0)")
            
            self.listShowing(index: ViewingList.History.rawValue)
            
            if $0 == "" {
                if let histoyTableView = self.histoyTableView {
                    histoyTableView.setData(strArr: self.viewModel.allHistorySubject.value, initial: false)
                }
            } else {
                self.viewModel.initialSort(text: $0)
            }
        }).disposed(by: disposeBag)
         
        viewModel.loadData()
    }
    
    func setupUI() {
        listShowing(index: ViewingList.History.rawValue)
        
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func listShowing(index: Int) {
        if let tableView = self.histoyTableView {
            tableView.removeFromSuperview()
        }
        
        if let tableView = self.searchListTableView {
            tableView.removeFromSuperview()
        }

        if index == ViewingList.History.rawValue {
            if let tableView = loadXib(type: SearchHistoryTableView.self) as? SearchHistoryTableView {
                histoyTableView = tableView
                tableView.historyTableViewDelegate = self
                contentView.addSubview(tableView)
            }
        } else if index == ViewingList.AppList.rawValue {
            if let tableView = loadXib(type: SearchListTableView.self) as? SearchListTableView {
                searchListTableView = tableView
                tableView.searchListTableViewDelegate = self
                contentView.addSubview(tableView)
            }
        }
    }
    
    func loadXib(type: Any) -> UITableView? {
        guard let loadedNib = Bundle.main.loadNibNamed(String(describing: type), owner: self, options: nil) else { return nil }
        guard let tableView = loadedNib.first as? UITableView else { return nil }
        tableView.frame = contentView.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return tableView
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
    
    func historySelect(title: String) {
        print("historySelect = ", title)
        self.searchController.searchBar.text = title
        self.searchController.searchBar.resignFirstResponder()
        self.searchController.isActive = true
//        self.searchController.dismiss(animated: true, completion: nil)
        searchListTableView?.setContentOffset(.zero, animated: false)
        
        dataLoadingVisible(isLoading: true)
        viewModel.searchUrl(text: title, page: 0, inheritance: false)
    }

//    func dataMoreLoad(page: Int) {
//        if let searchText = self.searchController.searchBar.text {
//            print("dataMoreLoad = ", page)
//            viewModel.searchUrl(text: searchText, page: page, inheritance: true)
//        }
//    }
        
}
 
