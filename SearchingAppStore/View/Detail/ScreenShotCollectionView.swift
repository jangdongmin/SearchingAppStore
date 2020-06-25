//
//  ScreenShotCollectionView.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/25.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class ScreenShotCollectionView: UICollectionView {
    var screenshotUrls: [String]?
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func setData(screenshotUrls: [String]) {
        self.screenshotUrls = screenshotUrls
        self.reloadData()
    }
}


extension ScreenShotCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScreenShotCollectionViewCell.self), for: indexPath) as? ScreenShotCollectionViewCell {
            
            if let screenshotUrls = screenshotUrls {
                if let imgUrl = URL(string: screenshotUrls[indexPath.row]) {
                    cell.screenShotImageVIew.loadImageTask(url: imgUrl, placeholder: nil)
                }
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width / 2 + UIScreen.main.bounds.size.width / 6, height: self.frame.size.height)
    }
}

class SnappingLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
