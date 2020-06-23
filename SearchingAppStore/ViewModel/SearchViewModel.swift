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
    
    let isTableViewHidden = BehaviorRelay<Bool>(value: false)
    
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
//        let observer: Observable<AppInfoDict> = self.apiClient.send(apiRequest: AppStoreRequest(term: text.lowercased(), limit: "\(page*10+10)", offset: "\(page*10)"))
        let observer: Observable<AppInfoDict> = self.apiClient.send(apiRequest: AppStoreRequest(term: text.lowercased()))
        observer.subscribe(onNext: {
            //print($0)
            if inheritance {
                var results = self.requestResult.value
                results.append(contentsOf: $0.results)
                self.requestResult.accept(results)
            } else {
                self.requestResult.accept($0.results)
            }
            
//            for i in 0..<$0.resultCount {
//                if let url = $0.results[i].trackViewUrl {
//                    if let webUrl = URL(string: url) {
//                        do {
//                            var htmlString = try String(contentsOf: webUrl, encoding: .utf8)
//                            if let range: Range<String.Index> = htmlString.range(of: "product-header__subtitle app-header__subtitle\">") {
//                                htmlString = String(htmlString[range.upperBound..<htmlString.endIndex])
//                                if let range: Range<String.Index> = htmlString.range(of: "</h2>") {
//                                    htmlString = String(htmlString[htmlString.startIndex..<range.lowerBound])
//                                    print(htmlString)
//
//                                    var results = self.requestResult.value
//                                    results[i].subTitle = htmlString
//                                    self.requestResult.accept(results)
//                                }
//                            }
//                        } catch let error {
//                            print("Error: \(error)")
//                        }
//                    }
//                }
//            }
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
}
