//
//  SearchViewController.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: class {
    func selectedPhoto(id: String)
}

class SearchViewController: BaseViewController {

    var searchWord: String = ""
    weak var delegate: SearchViewControllerDelegate?
    fileprivate var selectPhotoList : [[String: Any]] = []
    
    var naviView: SearchNaviView?
    @IBOutlet weak var collectionView: SearchCollectionView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    fileprivate let viewTitle: String = "search"
    fileprivate let itemKeyImage: String = "image"
    fileprivate let itemKeyItem: String = "item"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if selectPhotoList.count == 0 {
            return
        }
        
        selectPhotoList.forEach { (value) in
            if let image : UIImage = value[itemKeyImage] as? UIImage, let item : PhotoCellItem = value[itemKeyItem] as? PhotoCellItem {
                
                let data : Data = imageToJpeg(image: image)
                let name : String = "\(item.id).jpg"
                let documentsPath: String = DocumentsPath().appending("/\(name)")
                PhotoService.shared.writeFavoritePhoto(item: item, fileName: name)
                let url = NSURL(fileURLWithPath: documentsPath)
                try! data.write(to: url as URL)

                self.delegate?.selectedPhoto(id: item.id)
            }
        }
        selectPhotoList.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.title = viewTitle
        naviView = SearchNaviView.initView()
        self.navigationItem.titleView = naviView
        self.naviView?.delegate = self
        self.collectionView.searchViewDelegate = self
        self.reloadData()
    }

    func reloadData() {
        self.indicatorView.hidesWhenStopped = true
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PhotoService.shared.fetchData(page: 0, searchWord: searchWord) { [weak self] (items) in
            if let weakSelf = self {
                weakSelf.collectionView.cellItems = items
                weakSelf.collectionView.reloadData()
                weakSelf.indicatorView.stopAnimating()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    weakSelf.collectionView.firstAnimation()
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

            }
        }
    }
}


//MARK: - SearchCollectionViewDelegate
extension SearchViewController: SearchCollectionViewDelegate {
    
    func takeNextPage(page: Int) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PhotoService.shared.fetchData(page: page, searchWord: searchWord) { [weak self] (items) in
            if let weakSelf = self {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                weakSelf.collectionView.addNextPage(list: items)
            }
        }

    }
    
    func selectedPhoto(item: PhotoCellItem, image: UIImage) {
        if item.selected {
            selectPhotoList.append([itemKeyItem: item, itemKeyImage: image])
        }else{
            for (index, value) in selectPhotoList.enumerated() {
                if let i: PhotoCellItem = value[itemKeyItem] as? PhotoCellItem {
                    if i == item {
                        selectPhotoList.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
    func imageToJpeg(image : UIImage) -> Data{
        return UIImageJPEGRepresentation(image, 1.0)!
    }
}

//MARK: - SearchNaviViewDelegate
extension SearchViewController: SearchNaviViewDelegate {
    func tappedSearchButton(text: String) {
        searchWord = text
        self.collectionView.alpha = 0.0
        self.reloadData()
    }
}






