//
//  LoadMoreActivityIndicator.swift
//  SearchingAppStore
//
//  Created by Jang Dong Min on 2020/06/22.
//  Copyright © 2020 Paul Jang. All rights reserved.
//


import UIKit

class LoadMoreActivityIndicator {
    private let spacingFromLastCell: CGFloat
    private let spacingFromLastCellWhenLoadMoreActionStart: CGFloat
    private weak var activityIndicatorView: UIActivityIndicatorView?
    private weak var scrollView: UIScrollView?
    private var isBottom = false
    
    private var defaultY: CGFloat {
        guard let height = scrollView?.contentSize.height else { return 0.0 }
        return height + spacingFromLastCell
    }

    deinit { activityIndicatorView?.removeFromSuperview() }

    convenience init (scrollView: UIScrollView, isBottom: Bool) {
        self.init(scrollView: scrollView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 40, isBottom: isBottom)
    }
    
    init (scrollView: UIScrollView, spacingFromLastCell: CGFloat, spacingFromLastCellWhenLoadMoreActionStart: CGFloat, isBottom: Bool) {
        self.scrollView = scrollView
        self.spacingFromLastCell = spacingFromLastCell
        self.spacingFromLastCellWhenLoadMoreActionStart = spacingFromLastCellWhenLoadMoreActionStart
        let size:CGFloat = 40
        let frame = CGRect(x: (scrollView.frame.width-size)/2, y: scrollView.contentSize.height + spacingFromLastCell, width: size, height: size)
        let activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.color = .black
        activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        activityIndicatorView.hidesWhenStopped = true
        scrollView.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        
        self.isBottom = isBottom
    }

    private var isHidden: Bool {
        guard let scrollView = scrollView else { return true }
        return scrollView.contentSize.height < scrollView.frame.size.height
    }

    func start(closure: (() -> Void)?) {
        guard let scrollView = scrollView, let activityIndicatorView = activityIndicatorView else { return }
        let offsetY = scrollView.contentOffset.y
        activityIndicatorView.isHidden = isHidden
        if !isHidden && offsetY < 0 && !self.isBottom {
            activityIndicatorView.frame.origin.y = scrollView.frame.origin.y - activityIndicatorView.frame.size.height - spacingFromLastCell
            
            if !activityIndicatorView.isAnimating {
                if !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    closure?()
                }
            }
            
            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.top == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let top = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
                        }
                    }
                }
            }
        } else if !isHidden && offsetY >= 0 && self.isBottom {
            let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
            let offsetDelta = offsetY - contentDelta

            let newY = defaultY-offsetDelta
            if newY < scrollView.frame.height {
                activityIndicatorView.frame.origin.y = newY
            } else {
                if activityIndicatorView.frame.origin.y != defaultY {
                    activityIndicatorView.frame.origin.y = defaultY
                }
            }

            if !activityIndicatorView.isAnimating {
                if offsetY > contentDelta && offsetDelta >= spacingFromLastCellWhenLoadMoreActionStart && !activityIndicatorView.isAnimating {
                    activityIndicatorView.startAnimating()
                    closure?()
                }
            }

            if scrollView.isDecelerating {
                if activityIndicatorView.isAnimating && scrollView.contentInset.bottom == 0 {
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        if let bottom = self?.spacingFromLastCellWhenLoadMoreActionStart {
                            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
                        }
                    }
                }
            }
        }
    }

    func stop(completion: (() -> Void)? = nil) {
        guard let scrollView = scrollView , let activityIndicatorView = activityIndicatorView else { return }
        let contentDelta = scrollView.contentSize.height - scrollView.frame.size.height
        let offsetDelta = scrollView.contentOffset.y - contentDelta
        if offsetDelta >= 0 {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }) { _ in completion?() }
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            completion?()
        }
        activityIndicatorView.stopAnimating()
    }
}
