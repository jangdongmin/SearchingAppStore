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
    
    func dateConvert(component: DateComponents) -> String {
        if let year = component.year {
            if year != 0 {
                return "\(year)년 전"
            }
        }
        
        if let month = component.month {
            if month != 0 {
                return "\(month)개월 전"
            }
        }
        
        if let day = component.day {
            if day != 0 {
                if day < 7 {
                    return "\(day)일 전"
                } else {
                    return "\(day / 7)주 전"
                }
            }
        }
        
        if let hour = component.hour {
            if hour != 0 {
                return "\(hour)시간 전"
            }
        }
        
        if let minute = component.minute {
            if minute != 0 {
                return "1시간 전"
            }
        }
        
        return ""
    }
    
    func dateCompare (fromDate: Date, to: Date) -> DateComponents? {
        let cal = NSCalendar(calendarIdentifier:NSCalendar.Identifier(rawValue: NSCalendar.Identifier.gregorian.rawValue))
        let dateComponents = cal?.components([.hour, .day, .month, .year, .minute], from:fromDate, to:to, options:[])
        return dateComponents
    }
    
    
    func getDate(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //        dateFormatter.timeZone = TimeZone.current
        //        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)
    }
}
 
