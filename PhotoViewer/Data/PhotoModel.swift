//
//  PhotoModel.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/25.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class PhotoModel: Object {
    dynamic var id : String = ""
    dynamic var farm: Int = 0
    dynamic var secret: String = ""
    dynamic var server : String = ""
    dynamic var date : Date = Date()
    dynamic var filename: String = ""
    dynamic var deleted : Bool = false
}
