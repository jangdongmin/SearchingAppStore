//
//  DetailTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/23.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class DetailTableView: UITableView {
   
    enum CellName: String {
        case AppTitle = "appTitle"
        case ReleaseNote = "releaseNote"
        case ScreenShot = "screenShot"
    }
    
    var appInfo: AppInfo?
    var path = [Int:String]()
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    public func setData(appInfo: AppInfo) {
        self.appInfo = appInfo
        path.removeAll()
        
        if appInfo.releaseNotes != nil {
            path[0] = CellName.AppTitle.rawValue
            path[1] = CellName.ReleaseNote.rawValue
            path[2] = CellName.ScreenShot.rawValue
        } else {
            path[0] = CellName.AppTitle.rawValue
            path[1] = CellName.ScreenShot.rawValue
        }
        
        self.reloadData()
    }
}

extension DetailTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
        return UITableView.automaticDimension
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        return setDetailCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return path.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func setDetailCell(_ indexPath: IndexPath) -> UITableViewCell {
        if path[indexPath.row] == CellName.AppTitle.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self), for: indexPath) as? TitleCell {
                
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
        } else if path[indexPath.row] == CellName.ReleaseNote.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: RealseNoteCell.self), for: indexPath) as? RealseNoteCell {
                
                cell.realseNoteCellDelegate = self

                cell.timeLabel.text = ""
                cell.versionLabel.text = ""
                cell.releaseNoteLabel.text = appInfo?.releaseNotes
                
                print("actualNumberOfLines = ", cell.releaseNoteLabel.actualNumberOfLines)
                if cell.releaseNoteLabel.actualNumberOfLines > 2 && !cell.moreButtonClick {
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
        } else if path[indexPath.row] == CellName.ScreenShot.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: ScreenShotCell.self), for: indexPath) as? ScreenShotCell {
                
                if let appInfo = appInfo {
                    cell.screenShotCollectionView.setData(appInfo: appInfo)
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension DetailTableView: RealseNoteCellDelegate {
    func moreButtonClick(_ sender: Any) {
        print("moreButtonClick")
        //let indexPath = IndexPath(item: 0, section: 1)
        //self.reloadRows(at: [indexPath], with: .none)
        self.reloadData()
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

