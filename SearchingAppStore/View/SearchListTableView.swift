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
//    func dataMoreLoad(page: Int)
}

class SearchListTableView: UITableView {
    var page: Int = 0
    var contents: [AppInfo] = []
    //var isLoading = false
    
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
        return 350
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
            
            if let genres = appInfo.genres {
                cell.appDescLabel.text = genres[0]
//                if appInfo.subTitle != "" {
//                    cell.appDescLabel.text = appInfo.subTitle
//                }
            }
            
            if let userRatingCount = appInfo.userRatingCount {
                cell.userRatingCountLabel.text = "\(numberCutting(userRatingCount))"
            }
             
            if let artworkUrl100 = appInfo.artworkUrl100 {
                if let imgUrl = URL(string: artworkUrl100) {
                    cell.appIconImageView.loadImageTask(url: imgUrl, placeholder: nil)
                }
            }
             
            if let screenshotUrls = appInfo.screenshotUrls {
                if let imgUrl = URL(string: screenshotUrls[0]) {
                    cell.main_1_ImageView.loadImageTask(url: imgUrl, placeholder: nil)
                }
                
                if let imgUrl = URL(string: screenshotUrls[1]) {
                    cell.main_2_ImageView.loadImageTask(url: imgUrl, placeholder: nil)
                }
                
                if let imgUrl = URL(string: screenshotUrls[2]) {
                    cell.main_3_ImageView.loadImageTask(url: imgUrl, placeholder: nil)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func numberCutting(_ userRatingCount: Int) -> String {
        if userRatingCount < 1000 {
            return String(userRatingCount)
        } else if userRatingCount < 10000 { //천단위
            let str = Array(String(userRatingCount))
            return "\(str[0]).\(str[1])천"
        } else if userRatingCount < 100000 { //만단위
            let str = Array(String(userRatingCount))
            return "\(str[0]).\(str[1])만"
        } else { //만단위 이상
            let first = userRatingCount / 10000
            let result = userRatingCount - first * 10000
            let second = result / 1000
            return "\(first).\(second)만"
        }
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
