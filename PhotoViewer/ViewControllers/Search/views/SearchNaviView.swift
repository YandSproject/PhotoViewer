//
//  SearchNaviView.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit

protocol SearchNaviViewDelegate: class {
    func tappedSearchButton(text: String)
}

class SearchNaviView: UIView {

    @IBOutlet weak var textView: UITextField!
    weak var delegate : SearchNaviViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let accessoryView : AccessoryView = AccessoryView.initView()
        accessoryView.delegate = self
        textView.inputAccessoryView = accessoryView
        textView.delegate = self
    }
    
    static func initView() -> SearchNaviView{
        return Bundle.main.loadNibNamed(SearchNaviView.className(), owner: self, options: nil)?.first as! SearchNaviView
    }
    
    @IBAction func tappedButton(_ sender: UIButton) {
        self.goSearch()
    }
    
    func goSearch() {
        self.textView.resignFirstResponder()
        if let text : String = textView.text {
            if text == "" {
                return
            }
            self.delegate?.tappedSearchButton(text: text)
        }
    }
}

extension SearchNaviView : AccessoryViewDelegate {
    func closeKeyboard() {
        self.textView.resignFirstResponder()
    }
}

extension SearchNaviView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.goSearch()
        return true
    }
}
