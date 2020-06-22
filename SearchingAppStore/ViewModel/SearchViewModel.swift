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
    let apiClient = APIClient()
    
    let allHistorySubject = BehaviorRelay(value: [""])
    let sortHistorySubject = BehaviorRelay(value: [""])
    let requestResult = PublishSubject<AppInfoDict>()
    let disposeBag = DisposeBag()
    
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
    
    func searchUrl(text: String) {
        let observer: Observable<AppInfoDict> = self.apiClient.send(apiRequest: AppStoreRequest(term: text.lowercased()))
        observer.subscribe(onNext: { result in
//            print(result)
            self.requestResult.onNext(result)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
//    func prepareData(_ result: AppInfoDict) -> AppInfoDict {
//        var appInfoDict = result
//        for i in 0..<appInfoDict.results.count {
//            var appInfo = appInfoDict.results[i]
//
//            appInfo.averageUserRatingHead = Int(appInfo.averageUserRating ?? 0)
//            appInfo.averageUserRatingTail = appInfo.averageUserRating?.truncatingRemainder(dividingBy: 1) ?? 0
//
//            appInfoDict.results[i] = appInfo
//        }
//
//        return appInfoDict
//    }
}
