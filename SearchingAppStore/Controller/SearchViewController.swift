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
    
    @IBOutlet weak var histoyTableView: SearchHistoryTableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for university"
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
        
        viewModel.appDetailInfo.subscribe {
            print("appDetailInfo")
            
        }.disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: {
            if let text = self.searchController.searchBar.text {
                self.viewModel.saveData(text: text)
                self.viewModel.loadData()
            }
            self.searchController.isActive = false
        }).disposed(by: disposeBag)
         
        searchController.searchBar.rx.cancelButtonClicked.asDriver(onErrorJustReturn: ()).drive(onNext: {
//            self.keyboardDown()
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty.subscribe(onNext: {
            print("searchBar.rx.text: \($0)")
            if $0 == "" {
                self.histoyTableView.setData(strArr: self.viewModel.allHistorySubject.value, initial: false)
            } else {
                self.viewModel.initialSort(text: $0)
            }
        }).disposed(by: disposeBag)
        
//        searchBar.rx.text.asObservable()
//            .map { ($0 ?? "").lowercased() }
//            .map { UniversityRequest(name: $0) }
//            .flatMap { request -> Observable<[UniversityModel]> in
//                return self.apiClient.send(apiRequest: request)
//        }.disposed(by: disposeBag)
        
//        .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
//            cell.textLabel?.text = model.name
//        }
        viewModel.loadData()
    }
    
    func setupUI() {
        searchController.searchBar.setValue("취소", forKey:"cancelButtonText")
        histoyTableView.searchHistoryTableViewDelegate = self
        
        navigationItem.searchController = searchController
        navigationItem.title = "University finder"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
//https://itunes.apple.com/search?term=카카오뱅크&country=kr&entity=software
extension SearchViewController: SearchHistoryTableViewDelegate {
    func select(index: Int) {
        print("index = ", index)
        
    }
}
 
