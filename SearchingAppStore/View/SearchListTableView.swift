//
//  SearchListTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol SearchListTableViewDelegate {
    func detailSelect(appInfo: AppInfo)
}

class SearchListTableView: UITableView {
    var initial: Bool = false
    var contents: [AppInfo] = []
    var searchText: String = ""
    var searchListTableViewDelegate: SearchListTableViewDelegate?
   
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    public func setData(appInfoArr: [AppInfo]) {
        contents = appInfoArr
        self.reloadData()
    }
}

extension SearchListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchListTableViewDelegate?.detailSelect(appInfo: contents[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 250
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchListTableViewCell.self), for: indexPath) as? SearchListTableViewCell {
             
            let appInfo = contents[indexPath.row]
            if let averageUserRating = appInfo.averageUserRating {
                starCheck(cell, averageUserRating)
            }
             
            
            return cell
        }
        return UITableViewCell()
    }
     
    func starCheck(_ cell: SearchListTableViewCell, _ averageUserRating: Double) {
        let head = Int(averageUserRating)
        let tail = averageUserRating.truncatingRemainder(dividingBy: 1)
        
        for i in 0..<cell.starImageArray.count {
            if head > i {
                cell.starImageArray[i].backgroundColor = .lightGray
            } else {
                cell.starImageArray[i].setRating(tail)
                break
            }
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}

