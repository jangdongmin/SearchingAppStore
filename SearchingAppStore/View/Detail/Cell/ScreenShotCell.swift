//
//  ScreenShotCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/25.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class ScreenShotCell: UITableViewCell {
     
    @IBOutlet weak var screenShotCollectionView: ScreenShotCollectionView!
    
    override func awakeFromNib() {
        screenShotCollectionView.decelerationRate = .fast
    }
    
}
