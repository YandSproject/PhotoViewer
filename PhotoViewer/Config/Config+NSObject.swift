//
//  Config+NSObject.swift
//  SimpleMemo
//
//  Created by 原口 弓子 on 2016/07/01.
//  Copyright © 2016年 原口 弓子. All rights reserved.
//

import Foundation
import UIKit

//public class Config_NSObject: NSObject {
//    
//    
//}
//

extension NSObject {
    ///クラス名を取得
    class func className() -> String {
        return String(NSStringFromClass(self).components(separatedBy: ".").last!)
    }
    ///スクリーンサイズ
    public func ScreenRect() -> CGRect {
        return UIScreen.main.bounds
    }
    ///アプリ名
    public func AppName() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
    ///アプリのバージョン
    public func AppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    ///使用言語 japan == ja
    public func UserLanguages() -> String {
        return NSLocale.preferredLanguages.first ?? ""
    }
    ///Documentsパス
    public func DocumentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}

func DLog(message: Any?,
          function: String = #function,
          file: String = #file,
          line: Int = #line) {
    #if DEBUG
        let url = NSURL(fileURLWithPath: file)
        let lastPath : NSString = NSString(string: url.lastPathComponent ?? "")
        let fileName = lastPath.deletingPathExtension
        if let msg : Any = message{
            print("\(fileName):\(function) L\(line) : \(msg)")
        }else{
            print("\(fileName):\(function) L\(line) : # nil value #")
        }
    #endif
}


