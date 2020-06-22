//
//  SearchViewModel.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SearchViewModel {
    let disposeBag = DisposeBag()
    let apiClient = APIClient()
    
    let allHistorySubject = BehaviorRelay(value: [""])
    let sortHistorySubject = BehaviorRelay(value: [""])
    
    let requestResult = BehaviorRelay(value: [AppInfo]())
    //let requestResult = PublishSubject<AppInfoDict>()
    //let inheritance = PublishSubject<AppInfoDict>()
    
    func initialSort(text: String) {
        let historyArr = allHistorySubject.value
        
        var sortArr = [String]()
        for historyText in historyArr {
            print((historyText.lowercased() as NSString).range(of: text.lowercased()), " historyText = ", historyText)
            if (historyText.lowercased() as NSString).range(of: text.lowercased()).lowerBound == 0 {
                sortArr.append(historyText)
            }
        }
        sortHistorySubject.accept(sortArr)
    }
    
    func loadData() {
        if let array = UserDefaults.standard.array(forKey: "history") as? [String] {
            allHistorySubject.accept(array)
        }
    }
    
    func saveData(text: String) {
        if text == "" {
            return
        }
        if var array = UserDefaults.standard.array(forKey: "history") as? [String] {
            if !array.contains(text) {
                array.insert(text, at: 0)
                UserDefaults.standard.set(array, forKey: "history")
            }
        } else {
            UserDefaults.standard.set([text], forKey: "history")
        }
    }
    
    func searchUrl(text: String, page: Int, inheritance: Bool) {
        let observer: Observable<AppInfoDict> = self.apiClient.send(apiRequest: AppStoreRequest(term: text.lowercased(), offset: "\(page*25)"))
        observer.subscribe(onNext: {
            print($0)
            if inheritance {
                var results = self.requestResult.value
                results.append(contentsOf: $0.results)
                self.requestResult.accept(results)
            } else {
                self.requestResult.accept($0.results)
            }
            
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
}
