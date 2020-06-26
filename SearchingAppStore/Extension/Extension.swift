//
//  Extension.swift
//  SearchingAppStore
//
//  Created by Paul Jang on 2020/06/23.
//  Copyright © 2020 Paul Jang. All rights reserved.
//

import UIKit

extension UILabel {
    var actualNumberOfLines: Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0, index = 0, lineRange = NSMakeRange(0, 1)

        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}

extension String {
    // 문자열 공백 삭제
    func stringTrim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    func languageCodeConvert() -> String {
        #if os(iOS)
        switch self {
        case "KO":                                 return "한국어"
        case "EN":                                 return "영어"
        case "FR":                                 return "프랑스어"
        case "DE":                                 return "독일어"
        case "ID":                                 return "인도네시아어"
        case "IT":                                 return "이탈리아어"
        case "JA":                                 return "일본어"
        case "PT":                                 return "포르투갈어"
        case "RU":                                 return "러시아어"
        case "ZH":                                 return "중국어"
        case "ES":                                 return "스페인어"
        case "TH":                                 return "태국어"
        case "TR":                                 return "터키어"
        case "VI":                                 return "베트남어"
        default: return self
        }
        #endif
    }
}
 
