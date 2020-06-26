//
//  ReviewCell.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/26.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    var reviews: [Review]?
    
    @IBOutlet weak var star_1_view: UIImageView!
    @IBOutlet weak var star_2_view: UIImageView!
    @IBOutlet weak var star_3_view: UIImageView!
    @IBOutlet weak var star_4_view: UIImageView!
    @IBOutlet weak var star_5_view: UIImageView!
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        setupUI()
    }
    
    public func setData(reviews: [Review]) {
        self.reviews = reviews
    }
    
    private func setupUI() {
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        star_1_view.isUserInteractionEnabled = true
        star_2_view.isUserInteractionEnabled = true
        star_3_view.isUserInteractionEnabled = true
        star_4_view.isUserInteractionEnabled = true
        star_5_view.isUserInteractionEnabled = true
        
        star_1_view.addGestureRecognizer( UITapGestureRecognizer(target: self, action:  #selector(self.star_1_viewTouchAction)) )
        
        star_2_view.addGestureRecognizer( UITapGestureRecognizer(target: self, action:  #selector(self.star_2_viewTouchAction)) )
        
        star_3_view.addGestureRecognizer( UITapGestureRecognizer(target: self, action:  #selector(self.star_3_viewTouchAction)) )
        
        star_4_view.addGestureRecognizer( UITapGestureRecognizer(target: self, action:  #selector(self.star_4_viewTouchAction)) )
        
        star_5_view.addGestureRecognizer( UITapGestureRecognizer(target: self, action:  #selector(self.star_5_viewTouchAction)) )
        
        let nib = UINib(nibName: String(describing: UserReviewCell.self), bundle: nil)
        reviewCollectionView.register(nib, forCellWithReuseIdentifier: String(describing: UserReviewCell.self))
    }
    
    @objc func star_1_viewTouchAction(sender : UITapGestureRecognizer) {
        fillStar(index: 1)
    }
    
    @objc func star_2_viewTouchAction(sender : UITapGestureRecognizer) {
        fillStar(index: 2)
    }
    
    @objc func star_3_viewTouchAction(sender : UITapGestureRecognizer) {
        fillStar(index: 3)
    }
    
    @objc func star_4_viewTouchAction(sender : UITapGestureRecognizer) {
        fillStar(index: 4)
    }
    
    @objc func star_5_viewTouchAction(sender : UITapGestureRecognizer) {
        fillStar(index: 5)
    }
    
    func fillStar(index: Int) {
        if index == 1 {
            star_1_view.image = UIImage(systemName: "star.fill")
            star_2_view.image = UIImage(systemName: "star")
            star_3_view.image = UIImage(systemName: "star")
            star_4_view.image = UIImage(systemName: "star")
            star_5_view.image = UIImage(systemName: "star")
        } else if index == 2 {
            star_1_view.image = UIImage(systemName: "star.fill")
            star_2_view.image = UIImage(systemName: "star.fill")
            star_3_view.image = UIImage(systemName: "star")
            star_4_view.image = UIImage(systemName: "star")
            star_5_view.image = UIImage(systemName: "star")
        } else if index == 3 {
            star_1_view.image = UIImage(systemName: "star.fill")
            star_2_view.image = UIImage(systemName: "star.fill")
            star_3_view.image = UIImage(systemName: "star.fill")
            star_4_view.image = UIImage(systemName: "star")
            star_5_view.image = UIImage(systemName: "star")
        } else if index == 4 {
            star_1_view.image = UIImage(systemName: "star.fill")
            star_2_view.image = UIImage(systemName: "star.fill")
            star_3_view.image = UIImage(systemName: "star.fill")
            star_4_view.image = UIImage(systemName: "star.fill")
            star_5_view.image = UIImage(systemName: "star")
        } else if index == 5 {
            star_1_view.image = UIImage(systemName: "star.fill")
            star_2_view.image = UIImage(systemName: "star.fill")
            star_3_view.image = UIImage(systemName: "star.fill")
            star_4_view.image = UIImage(systemName: "star.fill")
            star_5_view.image = UIImage(systemName: "star.fill")
        }
    }
}

extension ReviewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: reviewCollectionView.frame.size.width, height: reviewCollectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviews?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UserReviewCell.self), for: indexPath) as? UserReviewCell {

            if let review = self.reviews?[indexPath.row] {
                cell.userNameLabel.text = review.userName
                cell.contentTextView.text = review.content
                cell.titleLabel.text = review.title
                cell.timeLabel.text = "1일 전"
            }
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
}
