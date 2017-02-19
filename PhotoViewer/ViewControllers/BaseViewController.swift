//
//  BaseViewController.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func loadView() {
        let nib = UINib(nibName: self.classString(), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func classString() -> String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!;
    }
}
