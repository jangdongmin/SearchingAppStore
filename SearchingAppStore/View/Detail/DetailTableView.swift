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
        case Description = "description"
        case Developer = "developer"
        case Evaluate = "evaluate"
        case Review = "review"
        case Info = "info"
    }
    
    var appInfo: AppInfo?
    var path = [Int:String]()
    var isCheck = [Int:CGFloat]()
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        var nib = UINib(nibName: String(describing: TitleCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: TitleCell.self))
        
        nib = UINib(nibName: String(describing: MoreTextCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: MoreTextCell.self))
        
        nib = UINib(nibName: String(describing: ScreenShotCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: ScreenShotCell.self))
        
        nib = UINib(nibName: String(describing: DeveloperCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: DeveloperCell.self))
        
        nib = UINib(nibName: String(describing: EvaluateCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: EvaluateCell.self))
        
        nib = UINib(nibName: String(describing: ReviewCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: ReviewCell.self))
        
        nib = UINib(nibName: String(describing: InfoCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: InfoCell.self))
        
        nib = UINib(nibName: "DescriptionCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "DescriptionCell")
    }
    
    public func setData(appInfo: AppInfo) {
        self.appInfo = appInfo
        path.removeAll()
        
        if appInfo.releaseNotes != nil {
            path[0] = CellName.AppTitle.rawValue
            path[1] = CellName.ReleaseNote.rawValue
            path[2] = CellName.ScreenShot.rawValue
            path[3] = CellName.Description.rawValue
            path[4] = CellName.Developer.rawValue
            path[5] = CellName.Evaluate.rawValue
            path[6] = CellName.Review.rawValue
            path[7] = CellName.Info.rawValue
        } else {
            path[0] = CellName.AppTitle.rawValue
            path[1] = CellName.ScreenShot.rawValue
            path[2] = CellName.Description.rawValue
            path[3] = CellName.Developer.rawValue
            path[4] = CellName.Evaluate.rawValue
            path[5] = CellName.Review.rawValue
            path[6] = CellName.Info.rawValue
        }
        
        self.reloadData()
    }
}

extension DetailTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = isCheck[indexPath.row] {
            return height
        }
        return UITableView.automaticDimension
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return setDetailCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return path.count
    }
    
    func setDetailCell(_ indexPath: IndexPath) -> UITableViewCell {
        if path[indexPath.row] == CellName.AppTitle.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self), for: indexPath) as? TitleCell {
                
                cell.userRatingLabel.text = ""
                cell.userRatingCountLabel.text = ""
                cell.appIconImageView.image = nil
                cell.appNameLabel.text = ""
                cell.partLabel.text = ""
                cell.ageLabel.text = ""
                cell.appDescLabel.text = ""
                
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
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: MoreTextCell.self), for: indexPath) as? MoreTextCell {
                
                cell.moreTextCellDelegate = self

                cell.timeLabel.text = ""
                cell.versionLabel.text = ""
                cell.releaseNoteLabel.text = appInfo?.releaseNotes
                
                if cell.releaseNoteLabel.actualNumberOfLines > 2 {
                    cell.moreButton.isHidden = false
                } else {
                    cell.moreButton.isHidden = true
                }
                
                if let version = appInfo?.version {
                    cell.versionLabel.text = "버전 \(version)"
                } else {
                    cell.versionLabel.text = ""
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
                
                if let screenshotUrls = appInfo?.screenshotUrls {
                    cell.screenShotCollectionView.setData(screenshotUrls: screenshotUrls)
                    if let ipadScreenshotUrls = appInfo?.ipadScreenshotUrls {
                        if ipadScreenshotUrls.count > 0 {
                            cell.screenShotCellDelegate = self
                            cell.iPadScreenShotCollectionView.setData(screenshotUrls: ipadScreenshotUrls)
                        } else {
                            cell.dropButton.isHidden = true
                        }
                    }
                }
                
                return cell
            }
        } else if path[indexPath.row] == CellName.Description.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as? MoreTextCell {
                
                cell.moreTextCellDelegate = self
                cell.releaseNoteLabel.text = appInfo?.description
                
                if cell.releaseNoteLabel.actualNumberOfLines > 2 {
                    cell.moreButton.isHidden = false
                } else {
                    cell.moreButton.isHidden = true
                }
                
                return cell
            }
        } else if path[indexPath.row] == CellName.Developer.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: DeveloperCell.self), for: indexPath) as? DeveloperCell {
                 
                cell.developerLabel.text = appInfo?.artistName
                return cell
            }
        } else if path[indexPath.row] == CellName.Evaluate.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: EvaluateCell.self), for: indexPath) as? EvaluateCell {
                 
                cell.userRatingLabel.text = ""
                cell.userRatingCountLabel.text = ""
                
                if let userRatingCount = appInfo?.userRatingCount {
                    if let count = Util.sharedInstance.decimalWon(value: userRatingCount) {
                        cell.userRatingCountLabel.text = "\(count)개의 평가"
                    }
                }
                
                if let averageUserRating = appInfo?.averageUserRating {
                    cell.userRatingLabel.text = averageUserRating.demicalCutting(digits: 1)
                }

                return cell
            }
        } else if path[indexPath.row] == CellName.Review.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: ReviewCell.self), for: indexPath) as? ReviewCell {
                if appInfo != nil {
                    let reviews = [Review(userName: "장동민", starRate: 4.0, time: "2020", content: "안녕하세요. 장동민입니다.\n처음 뵙겠습니다. \n카카오뱅크 꼭 가고 싶습니다.", title: "합격하고 싶습니다."),
                                   Review(userName: "장동민", starRate: 4.0, time: "2020", content: "안녕하세요. 장동민입니다. API에 리뷰 데이터가 없어 테스트 데이터를 넣었습니다.", title: "졸리다...."),
                                   Review(userName: "아아", starRate: 4.0, time: "2020", content: "테스트 데이터입니다.", title: "흐암.")]
                     
                    cell.setData(reviews: reviews)
                }
                return cell
            }
        } else if path[indexPath.row] == CellName.Info.rawValue {
            if let cell = self.dequeueReusableCell(withIdentifier: String(describing: InfoCell.self), for: indexPath) as? InfoCell {
                if let appInfo = appInfo {
                    cell.infoCellDelegate = self
                    cell.setData(appInfo: appInfo)
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension DetailTableView: MoreTextCellDelegate, ScreenShotCellDelegate, InfoCellDelegate {
    func cellHeight(value: CGFloat) {
        for i in 0..<path.count {
            if path[i] == CellName.Info.rawValue {
                isCheck[i] = value
            }
        }
        
        self.beginUpdates()
        self.endUpdates()
    }
    
    func dropButtonClick() {
        self.beginUpdates()
        self.endUpdates()
    }
    
    func releaseNoteMoreButtonClick(_ sender: Any) {
        if path[1] == CellName.ReleaseNote.rawValue {
            self.beginUpdates()
            self.endUpdates()
        }
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

