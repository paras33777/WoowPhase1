//
//  ShowDetailIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 13/05/21.
//

import Foundation

enum StreamMethod {
    case liveTV
    case show
    case movie
}

class ShowDetailIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var show : Show?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let object = dict["VIDEO_STREAMING_APP"] as? [String : Any] {
            let some = Show(dict: object)
            self.show = some
        }
    }
    class Show {
        var serverData : [String: Any] = [:]
        var related_shows : [Related_Shows]?
        var show_name : String?
        var show_lang : String?
        var show_info : String?
        var show_id : Int?
        var imdb_rating : String?
        var genre_list : [Genre_List]?
        var season_list : [Season_List]?
        var show_poster : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let related_shows = dict["related_shows"] as? [[String : Any]] {
                self.related_shows = []
                for object in related_shows {
                    let some =  Related_Shows(dict: object)
                    self.related_shows?.append(some)
                    
                }
            }
            if let show_name = dict["show_name"] as? String {
                self.show_name = show_name
            }
            if let show_lang = dict["show_lang"] as? String {
                self.show_lang = show_lang
            }
            if let show_info = dict["show_info"] as? String {
                self.show_info = show_info
            }
            if let show_id = dict["show_id"] as? Int {
                self.show_id = show_id
            }
            if let imdb_rating = dict["imdb_rating"] as? String {
                self.imdb_rating = imdb_rating
            }
            if let genre_list = dict["genre_list"] as? [[String : Any]] {
                self.genre_list = []
                for object in genre_list {
                    let some =  Genre_List(dict: object)
                    self.genre_list?.append(some)
                    
                }
            }
            if let season_list = dict["season_list"] as? [[String : Any]] {
                self.season_list = []
                for object in season_list {
                    let some =  Season_List(dict: object)
                    self.season_list?.append(some)
                    
                }
            }
            if let show_poster = dict["show_poster"] as? String {
                self.show_poster = show_poster
            }
        }
        class Related_Shows {
            var serverData : [String: Any] = [:]
            var show_title : String?
            var show_poster : String?
            var show_id : Int?
            init(dict: [String: Any]){
                self.serverData = dict
                
                if let show_title = dict["show_title"] as? String {
                    self.show_title = show_title
                }
                if let show_poster = dict["show_poster"] as? String {
                    self.show_poster = show_poster
                }
                if let show_id = dict["show_id"] as? Int {
                    self.show_id = show_id
                }
            }
        }
        class Genre_List {
            var serverData : [String: Any] = [:]
            var genre_name : String?
            var genre_id : String?
            init(dict: [String: Any]){
                self.serverData = dict
                
                if let genre_name = dict["genre_name"] as? String {
                    self.genre_name = genre_name
                }
                if let genre_id = dict["genre_id"] as? String {
                    self.genre_id = genre_id
                }
            }
        }
        class Season_List {
            var serverData : [String: Any] = [:]
            var season_name : String?
            var season_poster : String?
            var season_id : Int?
            init(dict: [String: Any]){
                self.serverData = dict
                
                if let season_name = dict["season_name"] as? String {
                    self.season_name = season_name
                }
                if let season_poster = dict["season_poster"] as? String {
                    self.season_poster = season_poster
                }
                if let season_id = dict["season_id"] as? Int {
                    self.season_id = season_id
                }
            }
        }
    }
}
