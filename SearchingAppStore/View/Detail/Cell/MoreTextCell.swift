//
//  MoreTextCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/24.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit
 
protocol MoreTextCellDelegate: class {
    func releaseNoteMoreButtonClick(index: Int?)
}

class MoreTextCell: UITableViewCell {
    weak var moreTextCellDelegate: MoreTextCellDelegate?
    
    var index: Int?
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
 
    @IBAction func moreButtonClick(_ sender: Any) {
        releaseNoteLabel.numberOfLines = 0
        moreButton.isHidden = true
        moreTextCellDelegate?.releaseNoteMoreButtonClick(index: index)
    }
}
