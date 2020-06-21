//
//  SearchListTableView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol SearchListTableViewDelegate {
    func select(title: String)
}

class SearchListTableView: UITableView {
    var initial: Bool = false
    var contents: [String] = []
    var searchText: String = ""
    var searchListTableViewDelegate: SearchListTableViewDelegate?
   
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

extension SearchListTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchListTableViewDelegate?.select(title: contents[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 250
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchListTableViewCell.self), for: indexPath) as? SearchListTableViewCell {
             
            return cell
        }
        return UITableViewCell()
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return contents.count
        return 19
    }
}
