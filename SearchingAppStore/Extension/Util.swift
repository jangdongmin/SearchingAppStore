//
//  Util.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/23.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

class Util {
    static let sharedInstance = Util()
    private init() {}
    
    func starCheck(_ imageArr: [HorizontalView], _ averageUserRating: Double) {
        let head = Int(averageUserRating)
        let tail = averageUserRating.truncatingRemainder(dividingBy: 1)
        
        for i in 0..<imageArr.count {
            if head > i {
                imageArr[i].backgroundColor = .lightGray
            } else {
                imageArr[i].setRating(tail)
                break
            }
        }
    }
    
    func numberCutting(_ userRatingCount: Int, small: Bool) -> String {
        var resultStr = ""
        if userRatingCount < 1000 {
            resultStr = String(userRatingCount)
        } else if userRatingCount < 10000 { //천단위
            let str = Array(String(userRatingCount))
            resultStr = "\(str[0]).\(str[1])천"
        } else if userRatingCount < 100000 { //만단위
            let str = Array(String(userRatingCount))
            resultStr = "\(str[0]).\(str[1])만"
        } else { //만단위 이상
            let first = userRatingCount / 10000
            let result = userRatingCount - first * 10000
            let second = result / 1000
            resultStr = "\(first).\(second)만"
        }
        
        if small {
            return resultStr
        }
        
        return "\(resultStr)개의 평가"
    }
}
 
