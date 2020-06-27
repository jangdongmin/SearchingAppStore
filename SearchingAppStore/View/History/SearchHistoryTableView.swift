//
//  SearchHistoryTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol SearchHistoryTableViewDelegate: class {
    func historySelect(title: String)
}

class SearchHistoryTableView: UITableView {
    var initial: Bool = false
    var contents: [String] = []
    var searchText: String = ""
    weak var historyTableViewDelegate: SearchHistoryTableViewDelegate?
   
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
        
        setupUI()
    }
     
    public func setData(strArr: [String], initial: Bool) {
        contents = strArr
        self.initial = initial
        self.reloadData()
    }
    
    public func setData(searchText: String ,strArr: [String]) {
        contents = strArr
        self.initial = true
        self.searchText = searchText
        self.reloadData()
    }
    
    private func setupUI() {
        var nib = UINib(nibName: String(describing: SearchHistoryTableViewCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: SearchHistoryTableViewCell.self))
        
        nib = UINib(nibName: String(describing: SearchHistoryTitleTableViewCell.self), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: SearchHistoryTitleTableViewCell.self))
    }
}

extension SearchHistoryTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            historyTableViewDelegate?.historySelect(title: contents[indexPath.row - 1])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchHistoryTitleTableViewCell.self), for: indexPath) as? SearchHistoryTitleTableViewCell {
                
                return cell
            }
            
            return UITableViewCell()
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchHistoryTableViewCell.self), for: indexPath) as? SearchHistoryTableViewCell {
                
                cell.searchImageView.isHidden = !initial
                cell.titleLabel.textColor = .lightGray
                
                if initial {
                    let historyText = contents[indexPath.row - 1]
                    let attributedStr = NSMutableAttributedString(string: historyText)
                     
                    //print("searchText = ", searchText, " historyText = ", historyText)
                    print((historyText.lowercased() as NSString).range(of: searchText.lowercased()))
                    
                    if self.traitCollection.userInterfaceStyle == .dark {
                        cell.titleLabel.textColor = .gray
                        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: (historyText.lowercased() as NSString).range(of: searchText.lowercased()))
                    } else {
                        cell.titleLabel.textColor = .lightGray
                        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: (historyText.lowercased() as NSString).range(of: searchText.lowercased()))
                    }
                    
                    cell.titleLabel.attributedText = attributedStr
                    
                    cell.bottomLineImageView.isHidden = false
                } else {
                    cell.titleLabel.textColor = .systemBlue
                    cell.titleLabel.text = contents[indexPath.row - 1]
                    
                    if (indexPath.row - 1) > (contents.count - 2) {
                        cell.bottomLineImageView.isHidden = true
                    } else {
                        cell.bottomLineImageView.isHidden = false
                    }
                }
                
                return cell
            }
            return UITableViewCell()
        }
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count + 1
    }
}
