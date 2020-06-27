//
//  SearchListTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol SearchListTableViewDelegate: class {
    func detailSelect(appInfo: AppInfo)
//    func dataMoreLoad(page: Int)
}

class SearchListTableView: UITableView {
    var page: Int = 0
    var contents: [AppInfo] = []
    //var isLoading = false
    
    weak var searchListTableViewDelegate: SearchListTableViewDelegate?
    
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
        let nib = UINib(nibName: String(describing: SearchListTableViewCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: SearchListTableViewCell.self))
    }
}

extension SearchListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchListTableViewDelegate?.detailSelect(appInfo: contents[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchListTableViewCell.self), for: indexPath) as? SearchListTableViewCell {
             
            let appInfo = contents[indexPath.row]
            if let averageUserRating = appInfo.averageUserRating {
                Util.sharedInstance.starCheck(cell.starImageArray, averageUserRating)
            }
            
            if let trackName = appInfo.trackName {
                cell.appNameLabel.text = trackName
            }
            
            if let genres = appInfo.genres {
                cell.appDescLabel.text = genres[0]
            }
            
            if let userRatingCount = appInfo.userRatingCount {
                cell.userRatingCountLabel.text = "\(Util.sharedInstance.numberCutting(userRatingCount, small: true))"
            }
             
            if let artworkUrl60 = appInfo.artworkUrl60 {
                if let imgUrl = URL(string: artworkUrl60) {
                    cell.appIconImageView.loadImageTask(url: imgUrl, placeholder: nil)
                }
            }
             
            if let screenshotUrls = appInfo.screenshotUrls {
                if screenshotUrls.count > 0 {
                    if let imgUrl = URL(string: screenshotUrls[0]) {
                        cell.main_1_ImageView.loadImageTask(url: imgUrl, placeholder: nil)
                    }
                }
                
                if screenshotUrls.count > 1 {
                    if let imgUrl = URL(string: screenshotUrls[1]) {
                        cell.main_2_ImageView.loadImageTask(url: imgUrl, placeholder: nil)
                    }
                }
                
                if screenshotUrls.count > 2 {
                    if let imgUrl = URL(string: screenshotUrls[2]) {
                        cell.main_3_ImageView.loadImageTask(url: imgUrl, placeholder: nil)
                    }
                }
            }
            
            if let bundleId = appInfo.bundleId {
                //cell.appNameLabel.text = trackName
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}

//extension SearchListTableView {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        if maximumOffset - currentOffset <= 20.0 && maximumOffset > 0 {
//            if !isLoading {
//                print("reload")
//                isLoading = true
//
//                self.page += 1
//                self.searchListTableViewDelegate?.dataMoreLoad(page: self.page)
//            }
//        }
//    }
//}
