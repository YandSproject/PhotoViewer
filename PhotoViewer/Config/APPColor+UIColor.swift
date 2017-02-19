//
//  APPColor+UIColor.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

extension UIColor {
    static let base: UIColor = UIColor.RGBA(r: 244.0, g: 244.0, b: 198.0, a: 1.0)
    static let sub : UIColor = UIColor.RGBA(r: 193.0, g: 73.0, b: 68.0, a: 1.0)
    static let text : UIColor = UIColor.RGBA(r: 50.0, g: 46.0, b: 43.0, a: 1.0)

    ///カラー（0 - 1の値）
    static func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor{
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
