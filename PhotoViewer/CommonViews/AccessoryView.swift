//
//  AccessoryView.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/31.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol AccessoryViewDelegate: class {
    func closeKeyboard()
}

class AccessoryView: UIView {
    
    weak var delegate : AccessoryViewDelegate?

    static func initView() -> AccessoryView {
        return Bundle.main.loadNibNamed(AccessoryView.className(), owner: self, options: nil)!.first as! AccessoryView
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.delegate?.closeKeyboard()
    }
}
