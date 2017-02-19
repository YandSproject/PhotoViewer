//
//  ImageManager.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit
import Kingfisher

class ImageManager: NSObject {
    
    static let shared: ImageManager = ImageManager()

    func setImage(iv : UIImageView, path: String) {
        let url = URL(string: path)!
        iv.kf.setImage(with: url, options: [.transition(.fade(0.3))])
    }

    func createImageURL(farm: String, id: String, server: String, secret: String) -> String{
            return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg)"
            //    http://farm6.staticflickr.com/5819/30471506501_39f2c1594d.jpg
    }
    
    //画像を正方形に切り抜いて指定のサイズにリサイズ
    func resizeImage(image: UIImage, size: CGSize, completed:@escaping ((_ image: UIImage) -> Void)){
        DispatchQueue.global().async {
            // リサイズ
            let cImage: CGImage = image.cgImage!
            let cWidth: CGFloat  = CGFloat(cImage.width)
            let cHeight: CGFloat = CGFloat(cImage.height)
            var resizeWidth: CGFloat = 0, resizeHeight: CGFloat = 0
            
            if (cWidth < cHeight) {
                resizeWidth = size.width * 2.0
                resizeHeight = cHeight * resizeWidth / cWidth
            } else {
                resizeHeight = size.height * 2.0
                resizeWidth = cWidth * resizeHeight / cHeight
            }
            
            let resizeSize = CGSize(width: resizeWidth, height: resizeHeight)
            UIGraphicsBeginImageContextWithOptions(resizeSize, false, 1.0)
            
            image.draw(in: CGRect(x: 0, y: 0, width: resizeWidth, height: resizeHeight))
            
            let resizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // 切り抜き
            let cropRect  = CGRect(x: (CGFloat(resizeWidth) - (size.width * 2.0)) / 2, y: (CGFloat(resizeHeight) - (size.height * 2.0)) / 2, width: size.width * 2.0, height: size.height * 2.0)
            let cropRef   = resizeImage.cgImage!.cropping(to: cropRect)
            let cropImage = UIImage(cgImage: cropRef!)
            
            DispatchQueue.main.async {
                completed(cropImage)
            }
        }
    }

}
