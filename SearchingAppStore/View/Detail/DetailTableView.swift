//
//  DetailTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/23.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class DetailTableView: UITableView {
    var appInfo: AppInfo?
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    public func setData(appInfo: AppInfo) {
        self.appInfo = appInfo
        self.reloadData()
    }
}

extension DetailTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
        return UITableView.automaticDimension
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self), for: indexPath) as? TitleCell {
                
                if let averageUserRating = appInfo?.averageUserRating {
                    Util.sharedInstance.starCheck(cell.starImageArray, averageUserRating)
                    cell.userRatingLabel.text = averageUserRating.demicalCutting(digits: 1)
                }
                
                if let userRatingCount = appInfo?.userRatingCount {
                    cell.userRatingCountLabel.text = "\(Util.sharedInstance.numberCutting(userRatingCount, small: false))"
                }
                
                if let artworkUrl100 = appInfo?.artworkUrl100 {
                    if let imgUrl = URL(string: artworkUrl100) {
                        cell.appIconImageView.loadImageTask(url: imgUrl, placeholder: nil)
                    }
                }
                
                if let trackName = appInfo?.trackName {
                    cell.appNameLabel.text = trackName
                }
                
                if let genres = appInfo?.genres {
                    cell.partLabel.text = genres[0]
                }
                
                if let trackContentRating = appInfo?.trackContentRating {
                    cell.ageLabel.text = trackContentRating
                }
                
                if let sellerName = appInfo?.sellerName {
                    cell.appDescLabel.text = sellerName
                }
                
                return cell
            }
        } else if indexPath.section == 1 {
            if let releaseNotes = appInfo?.releaseNotes {
                if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RealseNoteCell.self), for: indexPath) as? RealseNoteCell {

                    cell.realseNoteCellDelegate = self
                    cell.tag = indexPath.row
                    
                    cell.timeLabel.text = ""
                    cell.versionLabel.text = ""
                    cell.releaseNoteLabel.text = releaseNotes
                    
                    print("actualNumberOfLines = ", cell.releaseNoteLabel.actualNumberOfLines)
                    if cell.releaseNoteLabel.actualNumberOfLines > 3 {
                        cell.moreButton.isHidden = false
                    } else {
                        cell.moreButton.isHidden = true
                    }
                    
                    if let version = appInfo?.version {
                        cell.versionLabel.text = "버전 \(version)"
                    }
                    
                    if let currentVersionReleaseDate = appInfo?.currentVersionReleaseDate {
                        if let releaseDate = Util.sharedInstance.getDate(date: currentVersionReleaseDate) {
                            if let dateCompare = Util.sharedInstance.dateCompare(fromDate: releaseDate, to: Date()) {
                                cell.timeLabel.text = Util.sharedInstance.dateConvert(component: dateCompare)
                            }
                        }
                    }
                    
                    return cell
                }
            } else {
                
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension DetailTableView: RealseNoteCellDelegate {
    func moreButtonClick(_ sender: Any) {
        print("moreButtonClick")
        let indexPath = IndexPath(item: 0, section: 1)
        self.reloadRows(at: [indexPath], with: .top)
    }
}

extension Double {
    func demicalCutting(digits: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor
        numberFormatter.minimumSignificantDigits = 2
        numberFormatter.maximumSignificantDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

