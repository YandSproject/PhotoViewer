//
//  AlbumCollectionViewCell.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/27.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupImage(image: UIImage) {
        self.imageView.image = image
    }
}



