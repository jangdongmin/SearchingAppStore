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
    func dataMoreLoad(title: String, page: Int)
}

class SearchListTableView: UITableView {
    var searchText: String = ""
    var page: Int = 0
    var contents: [AppInfo] = []
    
    var searchListTableViewDelegate: SearchListTableViewDelegate?
    var activityIndicator: LoadMoreActivityIndicator?
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        setupUI()
    }
    
    public func setData(appInfoArr: [AppInfo]) {
        contents = appInfoArr
        self.reloadData()
    }
    
    private func setupUI() {
        activityIndicator = LoadMoreActivityIndicator(scrollView: self, isBottom: true)
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
            
            if let trackName = appInfo.trackName {
                cell.appNameLabel.text = trackName
            }
            
            if let description = appInfo.description {
                cell.appDescLabel.text = description
            }
            
            if let userRatingCount = appInfo.userRatingCount {
                cell.userRatingCountLabel.text = "\(userRatingCount)"
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

extension SearchListTableView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator?.start {
            DispatchQueue.global(qos: .utility).async {
                //sleep(3)
                DispatchQueue.main.async { [weak self] in
                    if let vc = self {
                        vc.activityIndicator?.stop()
                        vc.page += 1
                        vc.searchListTableViewDelegate?.dataMoreLoad(title: vc.searchText, page: vc.page)
                    }
                }
            }
        }
    }
}
