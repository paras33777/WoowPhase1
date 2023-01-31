//
//  LiveTVIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 12/05/21.
//

import Foundation

enum FilterEnum: String {
    case newest = "new"
    case oldest = "old"
    case random = "rand"
    case aToZ = "alpha"
}

class LiveTVIncoming {
    var serverData : [String: Any] = [:]
    var total_records : Int?
    var tv : [TV]?
    var status_code : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let total_records = dict["total_records"] as? Int {
            self.total_records = total_records
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.tv = []
            for object in vIDEO_STREAMING_APP {
                let some =  TV(dict: object)
                self.tv?.append(some)
                
            }
        }
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
    }
    class TV {
        var serverData : [String: Any] = [:]
        var tv_id : Int?
        var tv_title : String?
        var tv_access : String?
        var tv_logo : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let tv_id = dict["tv_id"] as? Int {
                self.tv_id = tv_id
            }
            if let tv_title = dict["tv_title"] as? String {
                self.tv_title = tv_title
            }
            if let tv_access = dict["tv_access"] as? String {
                self.tv_access = tv_access
            }
            if let tv_logo = dict["tv_logo"] as? String {
                self.tv_logo = tv_logo
            }
        }
    }
}
