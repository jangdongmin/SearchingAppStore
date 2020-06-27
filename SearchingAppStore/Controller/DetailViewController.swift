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
            
//        if let artworkUrl60 = appInfo?.artworkUrl60 {
//            if let imgUrl = URL(string: artworkUrl60) {
//                Util.sharedInstance.imageLoad(url: imgUrl, placeholder: nil) { result in
//                    self.navigationController?.addLogoImage(image: result)
//                }
//             }
//        }

        setNavigationBar()
        setupUI()
        setupBind()
    }
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = .gray
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        
//        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).standardAppearance = appearance
//        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).scrollEdgeAppearance = appearance
//        UINavigationBar.appearance(whenContainedInInstancesOf: [UINavigationController.self]).compactAppearance = appearance
         
        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.shadowImage = UIImage()
     }
 
    func setupUI() {
        if let info = appInfo {
            detailTableView.setData(appInfo: info)
        }
    }
    
    func setupBind() {
        
    }
    
}
