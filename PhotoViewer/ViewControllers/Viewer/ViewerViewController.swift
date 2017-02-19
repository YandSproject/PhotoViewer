//
//  ViewerViewController.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class ViewerViewController: BaseViewController {

    var list : [FavoriteCellItem] = []
    var firstIndex : Int = 0
    var isFullScreen : Bool = false
    private let defBackColor: UIColor = UIColor.RGBA(r: 222.0, g: 184.0, b: 135.0, a: 1.0)
    private let animateDuration: TimeInterval = 0.5
    private let viewTitle: String = "Viewer"
    
    @IBOutlet weak var collectionView: ViewerCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.setup(itemList: list)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.scrollToFirstPosition(index: firstIndex)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        self.title = viewTitle
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func tap(sender: UIGestureRecognizer) {
        isFullScreen = !isFullScreen
        var color : UIColor = UIColor.black
        if !isFullScreen {
            color = defBackColor
        }
        UIView.animate(withDuration: animateDuration) {
            self.view.backgroundColor = color
        }
        self.navigationController?.setNavigationBarHidden(isFullScreen, animated: true)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func transitionCellImageView() -> UIImageView? {
        return collectionView?.visibleImageView()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isFullScreen
    }

}
