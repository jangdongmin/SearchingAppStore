//
//  DetailViewController.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/23.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var appInfo: AppInfo?
    
    @IBOutlet weak var detailTableView: DetailTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
           
        setupUI()
        setupBind()
    }
    
    func setupUI() {
        if let info = appInfo {
            detailTableView.setData(appInfo: info)
        }
    }
    
    func setupBind() {
        
    }
    
}
