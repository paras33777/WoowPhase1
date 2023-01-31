//
//  LiveTVDetailIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 15/05/21.
//

import Foundation

class LiveTVDetailsIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var user_plan_status : Int?
    var detail : TVDetail?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let user_plan_status = dict["user_plan_status"] as? Int {
            self.user_plan_status = user_plan_status
        }
        if let object = dict["VIDEO_STREAMING_APP"] as? [String : Any] {
            let some =  TVDetail(dict: object)
            self.detail = some }
    }
    class TVDetail {
        var serverData : [String: Any] = [:]
        var tv_url : String?
        var category_name : String?
        var tv_id : Int?
        var tv_url2 : String?
        var tv_access : String?
        var related_live_tv : [Related_Live_Tv]?
        var tv_cat_id : Int?
        var tv_url_type : String?
        var tv_title : String?
        var tv_url3 : String?
        var description : String?
        var tv_logo : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let tv_url = dict["tv_url"] as? String {
                self.tv_url = tv_url
            }
            if let category_name = dict["category_name"] as? String {
                self.category_name = category_name
            }
            if let tv_id = dict["tv_id"] as? Int {
                self.tv_id = tv_id
            }
            if let tv_url2 = dict["tv_url2"] as? String {
                self.tv_url2 = tv_url2
            }
            if let tv_access = dict["tv_access"] as? String {
                self.tv_access = tv_access
            }
            if let related_live_tv = dict["related_live_tv"] as? [[String : Any]] {
                self.related_live_tv = []
//                for object in related_live_tv {
//                    let some =  Related_Live_Tv(dict: object)
//                    self.related_live_tv?.append(some)
//                }
            }
            if let tv_cat_id = dict["tv_cat_id"] as? Int {
                self.tv_cat_id = tv_cat_id
            }
            if let tv_url_type = dict["tv_url_type"] as? String {
                self.tv_url_type = tv_url_type
            }
            if let tv_title = dict["tv_title"] as? String {
                self.tv_title = tv_title
            }
            if let tv_url3 = dict["tv_url3"] as? String {
                self.tv_url3 = tv_url3
            }
            if let description = dict["description"] as? String {
                self.description = description
            }
            if let tv_logo = dict["tv_logo"] as? String {
                self.tv_logo = tv_logo
            }
        }
    }
    
    class Related_Live_Tv {
        
    }
}
