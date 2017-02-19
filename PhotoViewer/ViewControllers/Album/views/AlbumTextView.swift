//
//  AlbumTextView.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol AlbumTextViewDelegate: class {
    func tappedSearchButton(text: String)
}

class AlbumTextView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: UITextField!
    @IBOutlet weak var topConstraint : NSLayoutConstraint!
    
    fileprivate let defaultTopConstant : CGFloat = 64.0
    fileprivate var hideTopConstant : CGFloat = 0
    fileprivate var scrollValue : CGFloat = 0.0
    fileprivate var isHide : Bool = false
    fileprivate let animationDuration: TimeInterval = 0.4
    
    weak var delegate : AlbumTextViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        Bundle.main.loadNibNamed(AlbumTextView.className(), owner: self, options: nil)
        self.addSubview(contentView)

        contentView.frame = self.bounds
        self.layoutIfNeeded()
        hideTopConstant = defaultTopConstant - self.frame.height
        
        let accessoryView : AccessoryView = AccessoryView.initView()
        accessoryView.delegate = self
        textView.inputAccessoryView = accessoryView
        textView.delegate = self
    }
    
    func hideKeyboard() {
        textView.resignFirstResponder()
    }
    
    func showKeyboard() {
        textView.becomeFirstResponder()
    }
    
    func animateView(yPoint: CGFloat) {
        if textView.isFirstResponder {
            self.hideKeyboard()
        }

        let constant : CGFloat = defaultTopConstant - yPoint
        if scrollValue < yPoint {
            //viewを閉じる
            if isHide == false && constant >= hideTopConstant && constant < defaultTopConstant{
                topConstraint.constant = constant
                self.superview?.layoutIfNeeded()
            }

            if constant <= hideTopConstant && isHide == false {
                self.autoCloseAnimation()
            }

        }else{
            //viewを開ける
            if topConstraint.constant >= hideTopConstant && isHide == true{
                self.autoOpenAnimation()
                
            }else if yPoint <= defaultTopConstant && yPoint > 0 {
                if self.topConstraint.constant != self.defaultTopConstant && self.topConstraint.constant != self.hideTopConstant {
                    topConstraint.constant = constant
                    self.superview?.layoutIfNeeded()
                }
            }
        }
        scrollValue = yPoint
    }
    
    func autoCloseAnimation() {
        isHide = true
        UIView.animate(withDuration: animationDuration, animations: {
            self.topConstraint.constant = self.hideTopConstant
            self.superview?.layoutIfNeeded()
            }, completion: { (Bool) in
        })
    }
    
    func autoOpenAnimation() {
        if self.isHide == false {
            return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.topConstraint.constant = self.defaultTopConstant
            self.superview?.layoutIfNeeded()
            }, completion: { (Bool) in
                self.isHide = false
        })
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        if let text : String = textView.text {
            if text == "" {
                return
            }
            self.delegate?.tappedSearchButton(text: text)
        }
    }
}

extension AlbumTextView : AccessoryViewDelegate {
    func closeKeyboard() {
        self.hideKeyboard()
    }
}

extension AlbumTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        }
        self.delegate?.tappedSearchButton(text: textField.text ?? "")
        return true
    }
}
