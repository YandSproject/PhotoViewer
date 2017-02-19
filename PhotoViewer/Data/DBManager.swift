//
//  DBManager.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/26.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager: NSObject {
    static let shared: DBManager = DBManager()
    let realm: Realm? = try! Realm()
    
    static func deleteAllData() {
        try! shared.realm?.write({
            shared.realm?.deleteAll()
        })
    }
    
}
