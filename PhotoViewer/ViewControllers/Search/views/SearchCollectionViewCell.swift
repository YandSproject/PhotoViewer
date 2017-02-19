//
//  SearchCollectionViewCell.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol SearchCollectionViewCellDelegate: class {
    func changeValue(cell: SearchCollectionViewCell, isSelected:Bool)
}

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    weak var delegate: SearchCollectionViewCellDelegate?
    @IBOutlet weak var starButton: AnimateButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(item: PhotoCellItem) {
        imageView.image = nil
        ImageManager.shared.setImage(iv: self.imageView, path: item.path ?? "")
        starButton.isSelected = item.selected
    }
    
    @IBAction func tappedSelectButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.changeValue(cell: self, isSelected: sender.isSelected)
    }

}
