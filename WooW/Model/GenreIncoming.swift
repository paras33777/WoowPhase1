//
//  GenreIncoming.swift
//  WooW
//
//  Created by MAC on 15/05/21.
//

import Foundation

class GenreIncoming {
    var serverData : [String: Any] = [:]
    var genres : [Genre]?
    var status_code : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.genres = []
            for object in vIDEO_STREAMING_APP {
                let some = Genre(dict: object)
                self.genres?.append(some)
                
            }
        }
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
    }
    class Genre {
        var serverData : [String: Any] = [:]
        var genre_id : Int?
        var genre_image : String?
        var genre_name : String?
        var isSelected: Bool = false
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let genre_id = dict["genre_id"] as? Int {
                self.genre_id = genre_id
            }
            if let genre_image = dict["genre_image"] as? String {
                self.genre_image = genre_image
            }
            if let genre_name = dict["genre_name"] as? String {
                self.genre_name = genre_name
            }
        }
    }
}
