//
//  LanguageIncoming.swift
//  WooW
//
//  Created by MAC on 15/05/21.
//

import Foundation

class LanguageIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var language : [Language]?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.language = []
            for object in vIDEO_STREAMING_APP {
                let some =  Language(dict: object)
                self.language?.append(some)
                
            }
        }
    }
    class Language {
        var serverData : [String: Any] = [:]
        var language_name : String?
        var language_id : Int?
        var language_image : String?
        var isSelected: Bool = false
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let language_name = dict["language_name"] as? String {
                self.language_name = language_name
            }
            if let language_id = dict["language_id"] as? Int {
                self.language_id = language_id
            }
            if let language_image = dict["language_image"] as? String {
                self.language_image = language_image
            }
        }
    }
}
