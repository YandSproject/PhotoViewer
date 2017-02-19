//
//  AnimateButton.swift
//  ButtonAnimation
//
//  Created by YUMIKO HARAGUCHI on 2016/10/20.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol ButtonDelegate : class{
    ///タップイベントが必要であれば。。
    func ButtonTapEvent(button : UIButton, isCancel: Bool)
}

@IBDesignable class AnimateButton: UIButton {
    
    private let duration : TimeInterval = 0.5
    private let damping : CGFloat = 0.5
    private let velocity : CGFloat = 0.0
    private let scale: CGFloat = 0.8
    
    weak var buttonDelegate : ButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
    }

    //MARK: タップイベント
    func tapBegin() {
        self.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity,
                       options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] () -> Void  in
            let transScale: CGFloat = self?.scale ?? 0.8
            self?.layer.transform = CATransform3DMakeScale(transScale, transScale, transScale)
        }) { (Bool) -> Void in }
    }
    
    func tapEnd() {
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity,
                       options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] () -> Void in
            self?.layer.transform = CATransform3DIdentity
        }) { (Bool) -> Void in }
        buttonDelegate?.ButtonTapEvent(button: self, isCancel: false)
    }
    
    func tapUpOutSide() {
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: damping, initialSpringVelocity: velocity,
                       options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self] () -> Void in
            self?.layer.transform = CATransform3DIdentity
        }) { (Bool) -> Void in  }
        buttonDelegate?.ButtonTapEvent(button: self, isCancel: true)
    }
}

//MARK: - プライベート
extension AnimateButton {
    fileprivate func initView() {
        self.addTarget(self, action: #selector(AnimateButton.tapBegin), for: UIControlEvents.touchDown)
        self.addTarget(self, action: #selector(AnimateButton.tapEnd), for: UIControlEvents.touchUpInside)
        self.addTarget(self, action: #selector(AnimateButton.tapUpOutSide), for: UIControlEvents.touchUpOutside)
        self.addTarget(self, action: #selector(AnimateButton.tapUpOutSide), for: UIControlEvents.touchCancel)
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.height / 2
    }
}
