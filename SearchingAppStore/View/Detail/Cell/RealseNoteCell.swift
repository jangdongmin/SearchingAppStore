//
//  RealseNoteCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/24.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit
 
protocol RealseNoteCellDelegate: class {
    func moreButtonClick(_ sender: Any)
}

class RealseNoteCell: UITableViewCell {
    weak var realseNoteCellDelegate: RealseNoteCellDelegate?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    var moreButtonClick = false

    override func awakeFromNib() {
    }
    
    @IBAction func moreButtonClick(_ sender: Any) {
        releaseNoteLabel.numberOfLines = 0
        moreButton.isHidden = true
        moreButtonClick = true
        realseNoteCellDelegate?.moreButtonClick(sender)
    }
}
