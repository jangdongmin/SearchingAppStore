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
    
    func decimalWon(value: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: value))
        
        return result
    }
    
    func bytesToMega(value: Int?) -> String {
        if let value = value {
            return String(format: "%.1f",  Double(value / 1024 / 1024))
        }
        return ""
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
    
    func getOSInfo() -> String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
    
    func imageLoad(url: URL, placeholder: UIImage?, cache: URLCache? = nil, callBack: @escaping (UIImage) -> ()) {
        let cache = cache ?? URLCache.shared
        let request = URLRequest(url: url)
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            callBack(image)
        } else {
//            self.image = placeholder
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    callBack(image)
                }
            }).resume()
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
//    func imageRatio(width: CGFloat, limit: CGFloat, horizon: Bool) -> (CGFloat, CGFloat) {
//        let widthStandard: CGFloat = (limit - 10)
//        let height: CGFloat = widthStandard / 0.75
//        return (widthStandard, height)
//    }
}
 

//else {
//    let widthStandard: CGFloat = 220
//    var result: CGFloat = 0
//    if width > widthStandard {
//        let height: CGFloat = widthStandard / 0.56
//        return (widthStandard, height)
//    } else {
//        result = width / widthStandard
//        let widthResult = CGFloat(result * UIScreen.main.bounds.width)
//        let height: CGFloat = width / 0.56
//        return (widthResult, height)
//    }
//}
