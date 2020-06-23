//
//  Extension+UIVIew.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/21.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIButton
{
    var circle = false

    @IBInspectable var circleV: Bool {
        get {
            return false
        }
        set {
            circle = newValue
            if newValue {
                let width = min(bounds.width, bounds.height)
                let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: width / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)

                let mask = CAShapeLayer()
                mask.path = path.cgPath
                layer.mask = mask
                layer.masksToBounds = true
            }
        }
    }
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if !circle {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

@IBDesignable class CustomImageView: UIImageView
{
    var circle = false

    @IBInspectable var circleV: Bool {
        get {
            return false
        }
        set {
            circle = newValue
            if newValue {
                let width = min(bounds.width, bounds.height)
                let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: width / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)

                let mask = CAShapeLayer()
                mask.path = path.cgPath
                layer.mask = mask
                layer.masksToBounds = true
            }  
        }
    }
    
    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            if !circle {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
 
  
