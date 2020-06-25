//
//  ScreenShotCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/25.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

protocol ScreenShotCellDelegate: class {
    func dropButtonClick()
}

class ScreenShotCell: UITableViewCell {
    weak var screenShotCellDelegate: ScreenShotCellDelegate?
    @IBOutlet weak var screenShotCollectionView: ScreenShotCollectionView!
    @IBOutlet weak var iPadScreenShotCollectionView: ScreenShotCollectionView!
    
    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var iPadScreenShotContentView: UIStackView!
    
    override func awakeFromNib() {
        screenShotCollectionView.decelerationRate = .fast
        iPadScreenShotCollectionView.decelerationRate = .fast
    }
    
    @IBAction func dropButtonClick(_ sender: Any) {
        iPadScreenShotContentView.isHidden = false
        dropButton.isHidden = true
        screenShotCellDelegate?.dropButtonClick()
    }
}
