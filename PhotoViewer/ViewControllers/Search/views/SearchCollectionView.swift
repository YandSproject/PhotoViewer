//
//  SearchCollectionView.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol SearchCollectionViewDelegate: class {
    func selectedPhoto(item: PhotoCellItem, image: UIImage)
    func takeNextPage(page: Int)
}

class SearchCollectionView: UICollectionView {

    var cellItems: [PhotoCellItem] = []
    weak var searchViewDelegate : SearchCollectionViewDelegate?
    fileprivate var currentPage : Int = 1
    let pageNum : Int = 20
    var isUpdate: Bool = false
    var isEndUpdate: Bool = false
    private let animateDuration: TimeInterval = 0.8
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    func setup() {
        self.alpha = 0.0

        self.layoutIfNeeded()
        self.register(UINib(nibName: SearchCollectionViewCell.className(), bundle: nil), forCellWithReuseIdentifier: SearchCollectionViewCell.className())
        self.delegate = self
        self.dataSource = self
    }
    
    func firstAnimation() {
        
        self.alpha = 1.0
        
        let point : CGPoint = CGPoint(x: -self.frame.width, y: 0)
        self.setContentOffset(point, animated: false)
        
        let point1 : CGPoint = CGPoint(x: self.frame.width / 2, y: 0)
        
        UIView.animate(withDuration: animateDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.setContentOffset(point1, animated: false)
            
        }) { [weak self] (Bool) -> Void in
            
            let point2 : CGPoint = CGPoint(x: 1, y: 0)
            UIView.animate(withDuration: self?.animateDuration ?? 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                self?.setContentOffset(point2, animated: false)
            }) { (Bool) -> Void in }
        }
    }
    
    func addNextPage(list: [PhotoCellItem]) {
        if list.count == 0 {
            isEndUpdate = true
            return
        }
        
        let lastNum : Int = cellItems.count
        cellItems.append(contentsOf: list)
        
        var indexPaths : [IndexPath] = []
        for (index, _) in list.enumerated() {
            indexPaths.append(IndexPath(row: index + lastNum, section: 0))
        }
        
        self.performBatchUpdates({ 
            self.insertItems(at: indexPaths)
            }) { (Bool) in
                self.isUpdate = false
        }
    }
}

//MARK: - UICollectionViewDelegate
extension SearchCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCollectionViewCell = self.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.className(), for: indexPath) as! SearchCollectionViewCell
        cell.setup(item: cellItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cellItems.count - 3 == indexPath.row && isUpdate == false && isEndUpdate == false{
            isUpdate = true
            currentPage += 1
            self.searchViewDelegate?.takeNextPage(page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
}

//MARK: - SearchCollectionViewCellDelegate
extension SearchCollectionView: SearchCollectionViewCellDelegate {
    func changeValue(cell: SearchCollectionViewCell, isSelected: Bool) {
        if let indexPath : IndexPath = self.indexPath(for: cell) {
            let item: PhotoCellItem = cellItems[indexPath.row]
            item.selected = isSelected
            if let image : UIImage = cell.imageView.image {
                self.searchViewDelegate?.selectedPhoto(item: item, image: image)
            }
        }
    }
}
