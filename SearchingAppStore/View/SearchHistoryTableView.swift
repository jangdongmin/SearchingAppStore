//
//  SearchHistoryTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol SearchHistoryTableViewDelegate {
    func select(title: String)
}

class SearchHistoryTableView: UITableView {
    var initial: Bool = false
    var contents: [String] = []
    var searchText: String = ""
    var searchHistoryTableViewDelegate: SearchHistoryTableViewDelegate?
   
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
        let loadingCellNib = UINib(nibName: "SearchHistoryTableViewHeader", bundle: nil)
        self.register(loadingCellNib, forCellReuseIdentifier: "SearchHistoryTableViewHeader")
    }
}

extension SearchHistoryTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchHistoryTableViewDelegate?.select(title: contents[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchHistoryTableViewCell.self), for: indexPath) as? SearchHistoryTableViewCell {
            
            cell.searchImageView.isHidden = !initial
            cell.titleLabel.textColor = .lightGray
            
            if initial {
                let historyText = contents[indexPath.row]
                let attributedStr = NSMutableAttributedString(string: historyText)
                 
                print("searchText = ", searchText, " historyText = ", historyText)
                print((historyText.lowercased() as NSString).range(of: searchText.lowercased()))
                
                attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: (historyText.lowercased() as NSString).range(of: searchText.lowercased()))
                cell.titleLabel.attributedText = attributedStr
                
                cell.bottomLineImageView.isHidden = false
            } else {
                cell.titleLabel.textColor = .blue
                cell.titleLabel.text = contents[indexPath.row]
                
                if indexPath.row > contents.count - 2 {
                    cell.bottomLineImageView.isHidden = true
                } else {
                    cell.bottomLineImageView.isHidden = false
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if initial {
            return nil
        } else {
            return tableView.dequeueReusableCell(withIdentifier:    "SearchHistoryTableViewHeader")
        }
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if initial {
            return 0
        } else {
            return 70
        }
    }
}
