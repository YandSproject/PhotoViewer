//
//  AppUIConfig.swift
//  SimpleMemo
//
//  Created by 原口 弓子 on 2016/07/07.
//  Copyright © 2016年 原口 弓子. All rights reserved.
//

import UIKit

class AppUIConfig: NSObject {

    ///ボールドフォント
    static func fontBold(font size : CGFloat) -> UIFont {
        return UIFont(name: "HiraKakuProN-W6", size: size)!
    }
    
    
    ///普通のフォント
    static func fontNormal(font size : CGFloat) -> UIFont {
        return UIFont(name: "HiraKakuProN-W3", size: size)!
    }
    
    
    ///NSDateを表示用に変換
    static func convertNSdateForString(date : Date?) -> String {
        let dateFormatter = DateFormatter()
        if let formatString = DateFormatter.dateFormat(fromTemplate: "yyyyMMMdd HH:mm", options: 0, locale: NSLocale.current) {
            dateFormatter.dateFormat = formatString
            
            let formattedDateString = dateFormatter.string(from: date ?? Date())
            return formattedDateString
        }
        
        return ""
    }
    
}
