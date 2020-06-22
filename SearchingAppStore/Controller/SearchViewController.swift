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
    @IBOutlet weak var searchTextField: UITextField!
    
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
        
        viewModel.requestResult.observeOn(MainScheduler.instance)
            .subscribe { result in
            if let error = result.error {
                print("requestResult = ", error)
            } else {
                self.searchListTableView.isHidden = false
                self.searchListTableView.setData(appInfoArr: result.element?.results ?? [])
                print("requestResult = ", result)
                
            }
        }.disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: {
            if let text = self.searchController.searchBar.text {
                self.viewModel.saveData(text: text)
                self.viewModel.loadData()
                
                self.viewModel.searchUrl(text: text)
            }
            
            self.searchController.isActive = false
        }).disposed(by: disposeBag)
         
        searchController.searchBar.rx.cancelButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: {
//            self.keyboardDown()
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
        histoyTableView.searchHistoryTableViewDelegate = self
        
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.title = "검색"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SearchViewController: SearchHistoryTableViewDelegate {
    func select(title: String) {
        print("title = ", title)
        viewModel.searchUrl(text: title)
    }
}
 
