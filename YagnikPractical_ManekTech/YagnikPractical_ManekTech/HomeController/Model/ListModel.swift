//
//  ListModel.swift
//  YagnikPractical_ManekTech
//
//  Created by Yagnik Suthar on 12/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import Foundation
struct ListModel {
    var status : Int?
    var resturant : [Resturant]?
    
    init() {}
    
    init(_ data:[String:Any]) {
        self.status = data["status"] as? Int
        self.resturant = data["data"] as? [Resturant]
    }
        
}

struct Resturant {
    var id : Int?
    var title : String?
    var phone_no : Int?
    var description : String?
    var rating : Int?
    var address : String?
    var city : String?
    var state : String?
    var country : String?
    var pincode : Int?
    var long : String?
    var lat : String?
    var created_at : String?
    var updated_at : String?
    var img : [Img]?

    init() {}
    
    init(_ data:[String:Any]) {
        self.id = data["id"] as? Int
        self.title = data["title"] as? String
        self.phone_no = data["phone_no"] as? Int
        self.description = data["description"] as? String
        self.rating = data["rating"] as? Int
        self.address = data["address"] as? String
        self.city = data["city"] as? String
        self.state = data["state"] as? String
        self.country = data["country"] as? String
        self.pincode = data["pincode"] as? Int
        self.long = data["long"] as? String
        self.lat = data["lat"] as? String
        self.created_at = data["created_at"] as? String
        self.updated_at = data["updated_at"] as? String
//        self.img = data["img"] as? [Img]
        if let imageArray = data["img"] as? [[String:Any]]{
            var images = [Img]()
            for i in imageArray {
                let img = Img(i)
                images.append(img)
            }
            self.img = images
        }
    }
}

struct Img {
    var id : Int?
    var main_id : Int?
    var image : String?
    var created_at : String?
    var updated_at : String?

    init() {}

    init(_ data:[String:Any]) {

        self.id = data["id"] as? Int
        self.main_id = data["main_id"] as? Int
        self.image = data["image"] as? String
        self.created_at = data["created_at"] as? String
        self.updated_at = data["updated_at"] as? String
    }

}
