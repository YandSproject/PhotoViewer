//
//  ViewerCollectionViewCell.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/27.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class ViewerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView : UIImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scrollView.delegate = self
        scrollView.addSubview(self.imageView)
    }
    
    func setup(item: FavoriteCellItem) {
        scrollView.zoomScale = 1.0
        scrollView.bounces = false
        self.imageView.image = nil
        let documentsPath: String = DocumentsPath().appending("/" + (item.fileName ?? ""))
        let image : UIImage = UIImage(contentsOfFile: documentsPath) ?? UIImage()

        var size : CGSize = CGSize.zero
        let width : CGFloat = ScreenRect().width
        let ratio : CGFloat = ScreenRect().width / image.size.width
        let height : CGFloat = ratio * image.size.height
        size = CGSize(width: width, height: height)

        self.imageView.frame = CGRect(x: (self.frame.width / 2) - (size.width / 2), y: (self.frame.height / 2) - (size.height / 2), width: size.width, height: size.height)
        self.imageView.image = image
    }
}


extension ViewerCollectionViewCell: UIScrollViewDelegate {
    // ピンチイン・ピンチアウト
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.self.imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateInset()

    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == 1.0 {
            scrollView.bounces = false
        }else {
            scrollView.bounces = true
        }
    }
    
    fileprivate func updateInset() {
        var rect: CGRect = self.imageView.frame
        let bounds: CGRect = self.scrollView.bounds
        
        rect.origin = CGPoint.zero
        if (rect.width < bounds.width) {
            rect.origin.x = floor((bounds.width - rect.width) * 0.5)
        }
        if (rect.height < bounds.height) {
            rect.origin.y = floor((bounds.height - rect.height) * 0.5)
        }
        imageView.frame = rect;
    }

}
