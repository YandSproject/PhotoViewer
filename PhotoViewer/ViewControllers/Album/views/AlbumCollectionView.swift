//
//  AlbumCollectionView.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/27.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol AlbumCollectionViewDelegate: class {
    func collectionViewDidScroll(point: CGPoint)
    func selectedPhoto(index: Int, list: [FavoriteCellItem])
}

class AlbumCollectionView: UICollectionView {
    
    var list: [FavoriteCellItem] = []
    weak var albumCollectionViewDelegate : AlbumCollectionViewDelegate?
    
    fileprivate let topMargin: CGFloat = 23.0
    fileprivate let bottomMargin: CGFloat = 24.0
    fileprivate let cellTotalMargin: CGFloat = 30.0
    fileprivate let defaultInsetY : CGFloat = 65.0
    fileprivate let duration : TimeInterval = 0.5
    fileprivate let damping : CGFloat = 0.5
    fileprivate let velocity : CGFloat = 0.0
    fileprivate let transformScale : CGFloat = 0.8

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        let nib : UINib = UINib(nibName: AlbumCollectionViewCell.className(), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: AlbumCollectionViewCell.className())
        
        self.contentInset = UIEdgeInsetsMake(defaultInsetY, 0, 0, 0)

    }
    
    func setup(list: [FavoriteCellItem]) {
        self.list = list
        self.reloadData()
    }

    func insert(items: [FavoriteCellItem]) {

        var indexPaths : [IndexPath] = []
        for (index, value) in items.enumerated() {
            indexPaths.append(IndexPath(row: index, section: 0))
            list.insert(value, at: 0)
        }
        
        self.performBatchUpdates({ 
            self.insertItems(at: indexPaths)
        }) { (Bool) in }
    }

    ///選択した画像を取得
    func selectImage() -> UIImage {
        if let indexPath : IndexPath = self.indexPathsForSelectedItems?.first {
            let item : FavoriteCellItem = list[indexPath.row]
            return UIImage(contentsOfFile: DocumentsPath().appending("/" + (item.fileName ?? ""))) ?? UIImage()
        }
        return UIImage()
    }
    
    ///選択したセルのframeを取得
    func selectRect(atIndex: Int) -> CGRect {
        self.layoutIfNeeded()
        
        let indexPath: IndexPath = IndexPath(row: atIndex, section: 0)
        var rect : CGRect = CGRect.zero
        
        var isMoveCell : Bool = false
        if let r : CGRect = self.cellForItem(at: indexPath)?.frame {
            rect = r
        }else{
            self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
            self.layoutIfNeeded()
            
            rect = self.cellForItem(at: indexPath)?.frame ?? CGRect.zero
            isMoveCell = true
        }
        
        var imageViewRect : CGRect = CGRect.zero
        var cellRect : CGRect = CGRect.zero
        if let cell : AlbumCollectionViewCell = self.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
            imageViewRect = cell.imageView?.frame ?? CGRect.zero
            cellRect = cell.frame
        }
        
        rect.origin.x += self.frame.minX + imageViewRect.minX
        rect.origin.y += self.frame.minY + imageViewRect.minY - self.contentOffset.y
        rect.size.width = imageViewRect.width
        rect.size.height = imageViewRect.height
        
        if rect.minY < defaultInsetY + self.contentInset.top + imageViewRect.minY && isMoveCell == false {
            self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.top, animated: false)
            rect.origin.y = defaultInsetY + self.contentInset.top + imageViewRect.minY + topMargin
        }else{
            if rect.minY > self.frame.height - bottomMargin - cellRect.height {
                self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
            }
        }
        return rect
    }
    
    ///選択したセルを透過したり戻したり
    func selectImageView(index: Int) -> UIImageView? {
        let indexPath: IndexPath = IndexPath(row: index, section: 0)
        if let cell : AlbumCollectionViewCell = self.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
            return cell.imageView
        }
        return nil
    }
}


//MARK: - UICollectionViewDelegate
extension AlbumCollectionView: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCollectionViewCell = self.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.className(), for: indexPath) as! AlbumCollectionViewCell
        let item: FavoriteCellItem = list[indexPath.row]
        if item.image == nil {
            let documentsPath: String = DocumentsPath().appending("/" + (item.fileName ?? ""))
            ImageManager.shared.resizeImage(image: UIImage(contentsOfFile: documentsPath) ?? UIImage(), size: cell.imageView.frame.size) { (image) in
                item.image = image
                cell.setupImage(image: image)
            }
            return cell
        }
        cell.setupImage(image: item.image ?? UIImage())
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fl : CGFloat = (self.frame.width - cellTotalMargin) / 2
        let size : CGSize = CGSize(width: fl, height: fl)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.albumCollectionViewDelegate?.selectedPhoto(index: indexPath.row, list: list)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = self.cellForItem(at: indexPath)
        cell?.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity,
                       options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] () -> Void  in
            let scale: CGFloat = self?.transformScale ?? 0.8
            cell?.layer.transform = CATransform3DMakeScale(scale, scale, scale)
        }) { (Bool) -> Void in }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = self.cellForItem(at: indexPath)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
            cell?.layer.transform = CATransform3DIdentity
            
        }) { (Bool) -> Void in }
    }
}

//MARK: - scroll event
extension AlbumCollectionView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point : CGPoint = CGPoint(x: 0, y: defaultInsetY + scrollView.contentOffset.y)
        if point.y + self.frame.height - defaultInsetY < self.contentSize.height {
            self.albumCollectionViewDelegate?.collectionViewDidScroll(point: point)
        }
    }
}
