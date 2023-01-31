//
//  CategoryIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 12/05/21.
//

import Foundation

class CategoryIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var categories : [Category]?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.categories = []
            for object in vIDEO_STREAMING_APP {
                let some =  Category(dict: object)
                self.categories?.append(some)
                
            }
        }
    }
    class Category {
        var serverData : [String: Any] = [:]
        var category_id : Int?
        var category_name : String?
        var isSelected: Bool = false
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let category_id = dict["category_id"] as? Int {
                self.category_id = category_id
            }
            if let category_name = dict["category_name"] as? String {
                self.category_name = category_name
            }
        }
    }
}
