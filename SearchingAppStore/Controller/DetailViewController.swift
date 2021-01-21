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
//    var rightBarButtonItem: UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setupNavigationBar()
        setupUI()
    }
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        appearance.backgroundColor = UIColor(named: "whiteNBlack")
        self.navigationController?.navigationBar.standardAppearance = appearance
         
        if let artworkUrl60 = appInfo?.artworkUrl60 {
            if let imgUrl = URL(string: artworkUrl60) {
                Util.sharedInstance.imageLoad(url: imgUrl, placeholder: nil) { [weak self] result in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async { [weak self] in
                        guard let `self` = self else { return }
                        self.addNavBarImage(image: result)
                    }
                }
             }
        }
    }
    
    func addNavBarImage(image: UIImage) {
        if navigationController != nil {
//            rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "plus.app"), style: .done, target: self, action: nil)
//            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
            let iconSize = 30
            let imageView = UIImageView(image: Util.sharedInstance.resizeImage(image: image, targetSize: CGSize(width: iconSize, height: iconSize)))
            imageView.frame = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)

            imageView.layer.borderColor = UIColor.systemGray5.cgColor
            imageView.layer.borderWidth = 1
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true

            navigationItem.titleView = imageView
            navigationItem.titleView?.isHidden = true
        }
    }
 
    func setupUI() {
        if let info = appInfo {
            detailTableView.setData(appInfo: info)
        }
        
        detailTableView.detailTableViewDelegate = self
    }
}

extension DetailViewController: DetailTableViewDelegate {
    func scroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            if self.navigationController != nil {
//                if let rightBarButtonItem = rightBarButtonItem {
//                    rightBarButtonItem.isEnabled = true
//                }
                navigationItem.titleView?.isHidden = false
                
                self.navigationController?.navigationBar.standardAppearance.configureWithTransparentBackground()
                if self.traitCollection.userInterfaceStyle == .dark {
                    self.navigationController?.navigationBar.standardAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialDark)
                } else {
                    self.navigationController?.navigationBar.standardAppearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterialLight)
                }
                
            }
        } else {
            if self.navigationController != nil {
//                if let rightBarButtonItem = rightBarButtonItem {
//                    rightBarButtonItem.isEnabled = false
//                }
                
                navigationItem.titleView?.isHidden = true
                
                self.navigationController?.navigationBar.standardAppearance.shadowColor = nil
                self.navigationController?.navigationBar.standardAppearance.shadowImage = nil
                self.navigationController?.navigationBar.standardAppearance.backgroundColor = UIColor(named: "whiteNBlack")
                self.navigationController?.navigationBar.standardAppearance.backgroundEffect = nil
            }
        }
    }
}


