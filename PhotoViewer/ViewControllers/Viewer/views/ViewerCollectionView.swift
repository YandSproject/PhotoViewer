//
//  ViewerCollectionView.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/27.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class ViewerCollectionView: UICollectionView {

    var list : [FavoriteCellItem] = []

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(itemList: [FavoriteCellItem]) {
        self.delegate = self
        self.dataSource = self
        let nib : UINib = UINib(nibName: ViewerCollectionViewCell.className(), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: ViewerCollectionViewCell.className())
        
        self.layoutIfNeeded()
        
        list = itemList
        self.reloadData()
    }
    
    func scrollToFirstPosition(index: Int) {
        self.scrollToItem(at: IndexPath(row: index, section: 0), at: UICollectionViewScrollPosition.left, animated: false)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    
    ///現在表示されている画像を取得
    func visibleImage() -> UIImage {
        if let indexPath : IndexPath = self.indexPath(for: self.visibleCells.first!) {
            let item : FavoriteCellItem = list[indexPath.row]
            return UIImage(contentsOfFile: DocumentsPath().appending("/" + (item.fileName ?? ""))) ?? UIImage()
        }
        return UIImage()
    }
    
    ///現在表示されているセルのframeを取得
    func visibleRect() -> CGRect {
        if let cell : ViewerCollectionViewCell = self.visibleCells.first as? ViewerCollectionViewCell {
            var imageViewRect : CGRect = CGRect.zero
            imageViewRect = cell.imageView.frame
            return imageViewRect
        }
        return CGRect.zero
    }
    
    func visibleImageView() -> UIImageView? {
        if let cell : ViewerCollectionViewCell = self.visibleCells.first as? ViewerCollectionViewCell {
            return cell.imageView
        }
        
        return nil
    }
 
    func visibleIndexPath() -> IndexPath {
        return self.indexPathsForVisibleItems.first ?? IndexPath(row: 0, section: 0)
    }
}


//MARK: - UICollectionView Delegate
extension ViewerCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ViewerCollectionViewCell = self.dequeueReusableCell(withReuseIdentifier: ViewerCollectionViewCell.className(), for: indexPath) as! ViewerCollectionViewCell
        cell.setup(item: list[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size : CGSize = CGSize(width: self.frame.width, height: self.frame.height)
        return size
    }
    
}
