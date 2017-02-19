//
//  AlbumViewController.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class AlbumViewController: BaseViewController {
    
    @IBOutlet weak var searchView: AlbumTextView!
    @IBOutlet weak var collectionView: AlbumCollectionView!
    
    var newSelectPhotos: [FavoriteCellItem] = []
    var selectedIndex: Int = 0
    
    fileprivate let viewTitle: String = "Album"
    fileprivate let idSegueSearch: String = "search"
    fileprivate let idSegueViewer: String = "viewer"
    fileprivate let idKeyIndex: String = "index"
    fileprivate let idKeyList: String = "list"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
        
        self.searchView.autoOpenAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if newSelectPhotos.count != 0 {
            self.collectionView.insert(items: newSelectPhotos)
            newSelectPhotos.removeAll()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.title = viewTitle
        searchView.delegate = self
        collectionView.albumCollectionViewDelegate = self
        let items: [FavoriteCellItem] = PhotoService.shared.readFavoritePhotoList()
        collectionView.setup(list: items)
        if items.count == 0 {
            searchView.showKeyboard()
        }
    }

    func transitionCellImageRect(index: Int) -> CGRect {
        self.view.layoutIfNeeded()
        return collectionView.selectRect(atIndex: index)
    }
    
    func transitionCellImageView(index: Int) -> UIImageView? {
        return collectionView.selectImageView(index: index)
    }
    
    @IBAction func tappedTrashButton(_ sender: UIBarButtonItem) {
        PhotoService.shared.deleteAllData()
        collectionView.setup(list: [])
        searchView.autoOpenAnimation()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == idSegueSearch {
            if let vc : SearchViewController = segue.destination as? SearchViewController {
                vc.searchWord = sender as? String ?? ""
                vc.delegate = self
            }
        }else if segue.identifier == idSegueViewer {
            if let vc : ViewerViewController = segue.destination as? ViewerViewController {
                if let item: [String: Any] = sender as? [String: Any] {
                    let index = item[idKeyIndex] as? Int ?? 0
                    let list : [FavoriteCellItem] = item[idKeyList] as? [FavoriteCellItem] ?? []
                    vc.list = list
                    vc.firstIndex = index
                }
            }
        }
    }
}


//MARK: - AlbumTextView Delegate
extension AlbumViewController: AlbumTextViewDelegate {
    func tappedSearchButton(text: String) {
        searchView.hideKeyboard()
        self.performSegue(withIdentifier: idSegueSearch, sender: text)
    }
}

//MARK: - AlbumCollectionView Delegate
extension AlbumViewController: AlbumCollectionViewDelegate {
    func collectionViewDidScroll(point: CGPoint) {
        searchView.animateView(yPoint: point.y)
    }
    func selectedPhoto(index: Int, list: [FavoriteCellItem]) {
        self.selectedIndex = index
        let item : [String: Any] = [idKeyIndex: index, idKeyList: list]
        self.performSegue(withIdentifier: idSegueViewer, sender: item)
    }
}

//MARK: - SearchViewController Delegate
extension AlbumViewController: SearchViewControllerDelegate {
    func selectedPhoto(id: String) {
        let item: FavoriteCellItem = PhotoService.shared.readFavoritePhoto(id: id)
        self.newSelectPhotos.append(item)
    }
}

//MARK: NavigationController delegate トランジション
extension AlbumViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let vc : ViewerViewController =  toVC as? ViewerViewController {
            let transition: ScaleTransition = ScaleTransition()
            transition.image = collectionView.selectImage()
            transition.fromRect = self.transitionCellImageRect(index: self.selectedIndex)
            transition.fromImageView = self.transitionCellImageView(index: self.selectedIndex)
            transition.toRect = ScreenRect()
            transition.toImageView = vc.transitionCellImageView()
            transition.isBack = false
            return transition
        }else if let vc: AlbumViewController =  toVC as? AlbumViewController {
            if let viewerVC: ViewerViewController = fromVC as? ViewerViewController {
                let index : IndexPath = viewerVC.collectionView.visibleIndexPath()
                let transition: ScaleTransition = ScaleTransition()
                transition.image = viewerVC.collectionView.visibleImage()
                transition.fromRect = viewerVC.collectionView.visibleRect()
                transition.toRect = vc.transitionCellImageRect(index: index.row)
                transition.isBack = true
                transition.fromImageView = viewerVC.transitionCellImageView()
                transition.toImageView = vc.transitionCellImageView(index: index.row)
                return transition
            }
        }
        return nil
    }
}
