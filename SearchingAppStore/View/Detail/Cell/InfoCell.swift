//
//  InfoCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/26.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol InfoCellDelegate: class {
    func cellHeight(value: CGFloat)
}

class InfoCell: UITableViewCell {
    var appInfo: AppInfo?
    var path = [Int:String]()
    weak var infoCellDelegate: InfoCellDelegate?
    
    @IBOutlet weak var infoDetailTableView: InfoDetailTableView!
    @IBOutlet weak var detailTableViewHeight: NSLayoutConstraint!
     
    func setData(appInfo: AppInfo) {
        self.appInfo = appInfo
        infoDetailTableView.setData(appInfo: appInfo)
        infoDetailTableView.infoDetailTableViewDelegate = self

        let frame = infoDetailTableView.rectForRow(at: IndexPath(row: 0, section: 0))
        detailTableViewHeight.constant = CGFloat(infoDetailTableView.path.count) * frame.size.height
    }
}

extension InfoCell: InfoDetailTableViewDelegate {
    func calculateHeight(index: Int) {
        var totalHeight: CGFloat = infoDetailTableView.frame.origin.y
        for i in 0..<infoDetailTableView.path.count {
            let frame = infoDetailTableView.rectForRow(at: IndexPath(row: i, section: 0))
            totalHeight += frame.size.height
        }
        detailTableViewHeight.constant = totalHeight
        infoCellDelegate?.cellHeight(value: totalHeight)
    }
}
 

