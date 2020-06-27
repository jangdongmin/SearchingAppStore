//
//  InfoDetailTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/26.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol InfoDetailTableViewDelegate: class {
    func calculateHeight(index: Int)
}

class InfoDetailTableView: UITableView {
    var appInfo: AppInfo?
    var path = [Int:String]()
    var isCheck = [Int:CGFloat]()
    weak var infoDetailTableViewDelegate: InfoDetailTableViewDelegate?
     
    enum CellName: String {
        case sellerName = "sellerName"
        case fileSize = "fileSize"
        case category = "category"
        case compatibility = "compatibility"
        case language = "language"
        case ageDegree = "ageDegree"
        case literaryProperty = "literaryProperty"
        case sellerUrl = "sellerUrl"
        case privacy = "privacy"
    }
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        setupUI()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: String(describing: InfoDetailCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: InfoDetailCell.self))
    }
    
    func setData(appInfo: AppInfo) {
        self.appInfo = appInfo
        cellSequence()
         
        self.reloadData()
    }
    
    func cellSequence() {
        var index = 0
        if (appInfo?.sellerName) != nil {
            path[index] = CellName.sellerName.rawValue
            index += 1
        }
        
        if (appInfo?.fileSizeBytes) != nil {
            path[index] = CellName.fileSize.rawValue
            index += 1
        }
        
        if (appInfo?.primaryGenreName) != nil {
            path[index] = CellName.category.rawValue
            index += 1
        }
        
        if let supportedDevices = appInfo?.supportedDevices {
            if supportedDevices.count > 0 {
                path[index] = CellName.compatibility.rawValue
                index += 1
            }
        }
        
        if let languageCodesISO2A = appInfo?.languageCodesISO2A {
            if languageCodesISO2A.count > 0 {
                path[index] = CellName.language.rawValue
                index += 1
            }
        }

        if (appInfo?.trackContentRating) != nil {
            path[index] = CellName.ageDegree.rawValue
            index += 1
        }

        if (appInfo?.artistName) != nil {
            path[index] = CellName.literaryProperty.rawValue
            index += 1
        }
        
        if (appInfo?.sellerUrl) != nil {
            path[index] = CellName.sellerUrl.rawValue
            index += 1
        }
        
        //개발자 웹 사이트로 대체
        if (appInfo?.sellerUrl) != nil {
            path[index] = CellName.privacy.rawValue
            index += 1
        }
    }
}

extension InfoDetailTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return path.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if path[indexPath.row] == CellName.compatibility.rawValue ||
            path[indexPath.row] == CellName.language.rawValue ||
            path[indexPath.row] == CellName.ageDegree.rawValue {
            if let cell = tableView.cellForRow(at: indexPath) as? InfoDetailCell {
                cell.sideView.isHidden = true
                cell.detailLabel.isHidden = false
                
                self.beginUpdates()
                self.endUpdates()
                
                infoDetailTableViewDelegate?.calculateHeight(index: indexPath.row)
                isCheck[indexPath.row] = cell.frame.size.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoDetailCell.self), for: indexPath) as? InfoDetailCell {
            
            if path[indexPath.row] == CellName.sellerName.rawValue {
                cell.titleLabel.text = "제공자"
                cell.contentLabel.text = appInfo?.sellerName
                cell.stateImageView.isHidden = true
                cell.detailLabel.isHidden = true
            } else if path[indexPath.row] == CellName.fileSize.rawValue {
                cell.titleLabel.text = "크기"
                if let fileSizeBytes = appInfo?.fileSizeBytes {
                    cell.contentLabel.text = "\(Util.sharedInstance.bytesToMega(value: Int(fileSizeBytes)))MB"
                }
                cell.stateImageView.isHidden = true
                cell.detailLabel.isHidden = true
            } else if path[indexPath.row] == CellName.category.rawValue {
                cell.titleLabel.text = "카테고리"
                if let primaryGenreName = appInfo?.primaryGenreName {
                    cell.contentLabel.text = primaryGenreName
                }
                cell.stateImageView.isHidden = true
                cell.detailLabel.isHidden = true
            } else if path[indexPath.row] == CellName.compatibility.rawValue {
                if isCheck[indexPath.row] != nil {
                    cell.detailLabel.isHidden = false
                } else {
                    cell.detailLabel.isHidden = true
                }
                
                cell.titleLabel.text = "호환성"
                if let supportedDevices = appInfo?.supportedDevices {
                    var modelName = UIDevice.modelName.stringTrim()
                    
                    //공백이 없어지지 않는다;;
                    let arr =  modelName.components(separatedBy: " ")
                    modelName = "\(arr[0])\(arr[1])"
                   
                    let userDeviceMatch = supportedDevices.filter({(item: String) -> Bool in
                        return (item.lowercased().range(of: modelName.lowercased())) != nil ? true : false
                    })
                    
                    let iPadDeviceMatch = supportedDevices.filter({(item: String) -> Bool in
                        return (item.lowercased().range(of: "ipad".lowercased())) != nil ? true : false
                    })
                    
                    let iPodDeviceMatch = supportedDevices.filter({(item: String) -> Bool in
                        return (item.lowercased().range(of: "ipod".lowercased())) != nil ? true : false
                    })
                    
                    let watchDeviceMatch = supportedDevices.filter({(item: String) -> Bool in
                        return (item.lowercased().range(of: "watch".lowercased())) != nil ? true : false
                    })
                    
                    print("modelName = ",modelName, " userDeviceMatch = ", userDeviceMatch)
                    
                    let systemVersion = UIDevice.current.systemVersion

                    var minimumOsVersion: String = "0.0.0"
                    if let version = appInfo?.minimumOsVersion {
                        minimumOsVersion = version
                    }
           
                    if userDeviceMatch.count > 0 && (systemVersion.compare(minimumOsVersion, options: .numeric) == .orderedDescending || systemVersion.compare(minimumOsVersion, options: .numeric) == .orderedSame) {
                        cell.contentLabel.text = "이 \(arr[0])와(과) 호환"
                        
                        var detailStr = "iOS \(minimumOsVersion)"
                        if watchDeviceMatch.count > 0 {
                            if (watchDeviceMatch[0].lowercased().range(of: "Watch4".lowercased()) != nil) {
                                detailStr += " 및 watchOS 4.0"
                            } else if (watchDeviceMatch[0].lowercased().range(of: "Watch3".lowercased()) != nil) {
                                detailStr += " 및 watchOS 3.0"
                            } else if (watchDeviceMatch[0].lowercased().range(of: "Watch2".lowercased()) != nil) {
                                detailStr += " 및 watchOS 2.0"
                            }
                        }
                        
                        if iPadDeviceMatch.count > 0 && iPodDeviceMatch.count > 0 {
                            cell.detailLabel.text = "\(detailStr) 버전 이상이 필요. \(arr[0]), iPad 및 iPod touch 기기와 호환됨."
                        } else if iPadDeviceMatch.count > 0 {
                            cell.detailLabel.text = "\(detailStr) 버전 이상이 필요. \(arr[0]), iPad 기기와 호환됨."
                        } else if iPodDeviceMatch.count > 0 {
                            cell.detailLabel.text = "\(detailStr) 버전 이상이 필요. \(arr[0]), iPod touch 기기와 호환됨."
                        } else {
                            cell.detailLabel.text = "\(detailStr) 버전 이상이 필요. \(arr[0]) 기기와(과) 호환."
                        }
                    }
                }
                
                if #available(iOS 13.0, *) {
                    cell.stateImageView.image = UIImage(systemName: "chevron.down")
                }
            } else if path[indexPath.row] == CellName.language.rawValue {
                if isCheck[indexPath.row] != nil {
                    cell.detailLabel.isHidden = false
                } else {
                    cell.detailLabel.isHidden = true
                }
                
                cell.titleLabel.text = "언어"
                if let languageCodesISO2A = appInfo?.languageCodesISO2A {
                    let localeID = Locale.preferredLanguages.first
                    var lanCode = "kr"
                    if let deviceLocale = (Locale(identifier: localeID!).languageCode) {
                        lanCode = deviceLocale
                    }
                        
                    let krMatch = languageCodesISO2A.filter({(item: String) -> Bool in
                        return (item.lowercased().range(of: lanCode.lowercased())) != nil ? true : false
                    })
                    
                    if krMatch.count > 0 {
                        cell.contentLabel.text = "한국어 외 \(languageCodesISO2A.count)개"
                    }
                    
                    var result = ""
                    for i in 0..<languageCodesISO2A.count {
                        if i == languageCodesISO2A.count - 1 {
                            result += "\(languageCodesISO2A[i].languageCodeConvert())"
                        } else {
                            result += "\(languageCodesISO2A[i].languageCodeConvert()), "
                        }
                    }
                    
                    cell.detailLabel.text = result
                }
            } else if path[indexPath.row] == CellName.ageDegree.rawValue {
                if isCheck[indexPath.row] != nil {
                    cell.detailLabel.isHidden = false
                } else {
                    cell.detailLabel.isHidden = true
                }
                
                cell.titleLabel.text = "연령 등급"
                if let trackContentRating = appInfo?.trackContentRating {
                    cell.contentLabel.text = "\(trackContentRating)"
                    cell.detailLabel.text = "\(trackContentRating)"
                }
            } else if path[indexPath.row] == CellName.literaryProperty.rawValue {
                cell.titleLabel.text = "저작권"
                
                cell.stateImageView.isHidden = true
                cell.detailLabel.isHidden = true
                
                if let artistName = appInfo?.artistName {
                    cell.contentLabel.text = "ⓒ \(artistName)"
                }
            } else if path[indexPath.row] == CellName.sellerUrl.rawValue {
                cell.titleLabel.text = "개발자 웹 사이트"

                cell.detailLabel.isHidden = true
                cell.contentLabel.isHidden = true
                
                if #available(iOS 13.0, *) {
                    cell.titleLabel.textColor = .link
                    
                    cell.stateImageView.image = UIImage(systemName: "safari")
                    cell.stateImageView.tintColor = .link
                } else {
                    cell.titleLabel.textColor = .systemBlue
                }
            } else if path[indexPath.row] == CellName.privacy.rawValue {
                cell.titleLabel.text = "개인정보 처리방침"
                
                cell.detailLabel.isHidden = true
                cell.contentLabel.isHidden = true
                if #available(iOS 13.0, *) {
                    cell.titleLabel.textColor = .link
                    
                    cell.stateImageView.image = UIImage(systemName: "hand.raised.fill")
                    cell.stateImageView.tintColor = .link
                } else {
                    cell.titleLabel.textColor = .systemBlue
                }
            }
    
            return cell
        }
        return UITableViewCell()
    }
    
    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
}
