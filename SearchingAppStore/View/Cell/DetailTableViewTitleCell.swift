//
//  DetailTableViewTitleCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/23.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class DetailTableViewTitleCell: UITableViewCell {
    @IBOutlet var appIconImageView: CustomImageView!
    
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var appDescLabel: UILabel!
    
    var starImageArray = [HorizontalView]()
    @IBOutlet var star_1_View: HorizontalView!
    @IBOutlet var star_2_View: HorizontalView!
    @IBOutlet var star_3_View: HorizontalView!
    @IBOutlet var star_4_View: HorizontalView!
    @IBOutlet var star_5_View: HorizontalView!
    
    @IBOutlet var userRatingCountLabel: UILabel!
    @IBOutlet var userRatingLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        starImageArray.append(star_1_View)
        starImageArray.append(star_2_View)
        starImageArray.append(star_3_View)
        starImageArray.append(star_4_View)
        starImageArray.append(star_5_View)
    }
}
