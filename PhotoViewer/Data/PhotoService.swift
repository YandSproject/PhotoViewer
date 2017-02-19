//
//  PhotoService.swift
//  PhotoViewer
//
//  Created by YUMIKO HARAGUCHI on 2016/10/25.
//  Copyright © 2016年 YUMIKO HARAGUCHI. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PhotoCellItem: NSObject {
    var path : String?
    var selected : Bool = false
    
    var id      : String = ""
    var farm    : Int = 0
    var secret  : String = ""
    var server  : String = ""
}

class FavoriteCellItem: NSObject {
    var id          : String = ""
    var fileName    : String?
    var date        : Date = Date()
    var image       : UIImage?
}

class PhotoService: NSObject {

    static let shared : PhotoService = PhotoService()
    fileprivate var comp:(([PhotoCellItem])-> Void)?
    
    ///APIからデータを取得
    func fetchData(page: Int, searchWord: String, completed:@escaping (([PhotoCellItem])-> Void)) {
        comp = completed
        self.fetch(page: page, searchWord: searchWord)
    }
    
    ///ユーザーが登録した全データを取得
    func readFavoritePhotoList() ->[FavoriteCellItem] {
        let result = self.readAllPhotoData()
        
        var list : [FavoriteCellItem] = []
        result?.forEach({ (r) in
            let item: FavoriteCellItem = FavoriteCellItem()
            item.id = r.id
            item.fileName = r.filename
            item.date = r.date
            list.append(item)
        })
        
        return list
    }
    
    ///ユーザーが登録したデータから特定のidのものを取得
    func readFavoritePhoto(id : String) -> FavoriteCellItem {
        let item: FavoriteCellItem = FavoriteCellItem()
        if let r = self.readPhotoData(id: id) {
            item.id = r.id
            item.fileName = r.filename
            item.date = r.date
        }
        return item
    }
    
    ///ユーザーが選択したものをDBに保存
    func writeFavoritePhoto(item: PhotoCellItem, fileName: String) {
        let model : PhotoModel = PhotoModel()
        model.id = item.id
        model.farm = item.farm
        model.secret = item.secret
        model.server = item.server
        model.date = Date()
        model.filename = fileName
        try? DBManager.shared.realm?.write {
            DBManager.shared.realm?.add(model)
        }
    }
    
    func deleteAllData() {
        DBManager.deleteAllData()
    }
}

//MARK: - フリッカーからデータを取得
extension PhotoService {
    fileprivate func fetch(page: Int, searchWord: String) {
        let word : String = searchWord.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? searchWord
        let url  = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=8f9067864c1a1567c1f6b990232fc033&text=\(word)&per_page=20&page=\(page)&format=json&nojsoncallback=1"
        Alamofire.request(url).responseJSON { [weak self] response in
            if let json = response.result.value {
                let items: [PhotoCellItem] = self?.createPhotoItem(json: json as! NSDictionary) ?? []
                self?.comp!(items)
            }
        }
    }
    
    fileprivate func createPhotoItem(json: NSDictionary) -> [PhotoCellItem]{
        let photos: NSDictionary = json["photos"] as! NSDictionary
        let photo: NSArray = photos["photo"] as! NSArray
        var items: [PhotoCellItem] = []
        photo.forEach { (dic) in
            if let d : NSDictionary = dic as? NSDictionary {
                if self.readPhotoData(id: d["id"] as? String ?? "") == nil {
                    let path: String = ImageManager.shared.createImageURL(farm: "\(d["farm"]!)", id:"\(d["id"]!)", server: "\(d["server"]!)", secret: "\(d["secret"]!)")
                    let item: PhotoCellItem = PhotoCellItem()
                    item.path = path
                    item.id = d["id"] as? String ?? ""
                    item.farm = d["farm"] as? Int ?? 0
                    item.secret = d["secret"] as? String ?? ""
                    item.server = d["server"] as? String ?? ""
                    items.append(item)
                }
            }
        }
        return items
    }
}

//MARK: - DB
extension PhotoService {
    fileprivate func readAllPhotoData() -> Results<PhotoModel>?{
        if let result: Results<PhotoModel> = DBManager.shared.realm?.objects(PhotoModel.self).filter("deleted = false").sorted(byProperty: "date", ascending: false) {
            return result
        }
        return nil
    }
    
    fileprivate func readPhotoData(id: String) -> PhotoModel? {
        let predicate : NSPredicate = NSPredicate(format: "deleted = false && id = %@", id)
        if let r: Results<PhotoModel> = DBManager.shared.realm?.objects(PhotoModel.self).filter(predicate).sorted(byProperty: "date") {
            return r.first
        }
        return nil
    }
}
