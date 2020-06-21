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
    private let apiClient = APIClient()
    
    let allHistorySubject = BehaviorRelay(value: [""])
    let sortHistorySubject = BehaviorRelay(value: [""])
    
    let appDetailInfo = PublishSubject<History>()
    
    
    func initialSort(text: String) {
        let historyArr = allHistorySubject.value
        
        var sortArr = [String]()
        for historyText in historyArr {
            if (historyText as NSString).range(of: text.lowercased()).lowerBound == 0 {
                sortArr.append(text.lowercased())
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
        if var array = UserDefaults.standard.array(forKey: "history") {
            array.insert(text, at: 0)
            UserDefaults.standard.set(array, forKey: "history")
        } else {
            UserDefaults.standard.set([text], forKey: "history")
        }
    }
    
     
}
