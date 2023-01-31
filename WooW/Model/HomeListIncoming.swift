//
//  HomeListIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 06/05/21.
//

import Foundation

class HomeModel {
    var serverData: [String:Any]?
    var data = [Response]()
    var banners = [Banner]()
    var tempDict = [String:Any]()
    
    init(dict: [String:Any]) {
        guard let json = dict["VIDEO_STREAMING_APP"] as? [String:Any] else {
            return
        }
        
        self.tempDict = json
        if let slider = json["slider"] as? [[String : Any]] {
            self.banners = []
            for object in slider {
                let some = Banner(dict: object)
                self.banners.append(some)
            }
        }
        
//        for _ in 0..<12 {
//            let response = HomeModel.Response(json: tempDict, home: self)
//            if response.movies == nil &&
//                response.shows == nil &&
//                response.recentlyWatched == nil {
//            } else {
//                data.append(response)
//            }
//        }
        
        if let recently_watched = json["recently_watched"] as? [[String:Any]] {
            let recWatchDict = ["recently_watched": recently_watched]
            let response = HomeModel.Response(json: recWatchDict, home: self, i: 0)
            if response.movies == nil &&
                response.shows == nil &&
                response.recentlyWatched == nil {
            } else {
                data.append(response)
            }
        }
        
        
        if let index = self.tempDict.index(forKey: "recently_watched") {
            self.tempDict.remove(at: index)
        }
        if let index = self.tempDict.index(forKey: "slider") {
            self.tempDict.remove(at: index)
        }
        
        let keysCount = (json.keys.count - 2) / 4
        for i in 1...keysCount {
            let response = HomeModel.Response(json: tempDict, home: self, i: i)
            if response.movies == nil &&
                response.shows == nil &&
                response.recentlyWatched == nil {
                
            } else {
                data.append(response)
            }
        }
    }
    
    class Response {
        var type : String?
        var title : String?
        var lang_id : String?
        var movies : [Movies]?
        var shows : [Shows]?
        var recentlyWatched : [RecentlyWatched]?
        
        init(json: [String:Any], home: HomeModel, i: Int) {
            if let recently_watched = json["recently_watched"] as? [[String:Any]] {
                if recently_watched.count > 0 {
                    self.title = "Recently Watched"
                    self.type = "RecentWatch"
                    self.recentlyWatched = [RecentlyWatched]()
                    
                    for each in recently_watched {
                        let recent = RecentlyWatched(dict: each)
                        self.recentlyWatched?.append(recent)
                    }
                }
                home.tempDict.removeValue(forKey: "recently_watched")
                return
            }
            
            if let type = json["home_sections\(i)_type"] as? String {
                self.type = type
                self.title = (json["home_sections\(i)_title"] as? String) ?? ""
                self.lang_id = (json["home_sections\(i)_lang_id"] as? String) ?? ""
                self.movies = [Movies]()
                self.shows = [Shows]()
                if let list = json["home_sections\(i)"] as? [[String:Any]] {
                    for each in list {
                        if Movies(dict: each).movie_id != nil {
                            let movie = Movies(dict: each)
                            self.movies?.append(movie)
                        } else if Shows(dict: each).show_id != nil {
                            let show = Shows(dict: each)
                            self.shows?.append(show)
                        }
                    }
                }
                home.tempDict.removeValue(forKey: "home_sections\(i)_type")
                home.tempDict.removeValue(forKey: "home_sections\(i)_title")
                home.tempDict.removeValue(forKey: "home_sections\(i)_lang_id")
                home.tempDict.removeValue(forKey: "home_sections\(i)")
                return
            }
            
            /*if let latest_movies = json["latest_movies"] as? [[String:Any]] {
                if latest_movies.count > 0 {
                    self.title = "Recommended Movies"
                    self.type = "Movie"
                    self.movies = [Movies]()
                    for each in latest_movies {
                        let movie = Movies(dict: each)
                        self.movies?.append(movie)
                    }
                }
                home.tempDict.removeValue(forKey: "latest_movies")
                return
            }

            if let latest_shows = json["latest_shows"] as? [[String:Any]] {
                if latest_shows.count > 0 {
                    self.title = "Latest Shows"
                    self.type = "Shows"
                    self.shows = [Shows]()
                    for each in latest_shows {
                        let show = Shows(dict: each)
                        self.shows?.append(show)
                    }
                }
                home.tempDict.removeValue(forKey: "latest_shows")
                return
            }
            if let popular_movies = json["popular_movies"] as? [[String:Any]] {
                if popular_movies.count > 0 {
                    self.title = "Trending Movies"
                    self.type = "Movie"
                    self.movies = [Movies]()
                    for each in popular_movies {
                        let movie = Movies(dict: each)
                        self.movies?.append(movie)
                    }
                }
                home.tempDict.removeValue(forKey: "popular_movies")
                return
            }
            
            
            if let popular_shows = json["popular_shows"] as? [[String:Any]] {
                if popular_shows.count > 0 {
                    self.title = "Popular Shows"
                    self.shows = [Shows]()
                    for each in popular_shows {
                        let show = Shows(dict: each)
                        self.shows?.append(show)
                    }
                }
                home.tempDict.removeValue(forKey: "popular_shows")
                return
            }
            
            if let type = json["home_sections3_type"] as? String {
                self.type = type
                self.title = (json["home_sections3_title"] as? String) ?? ""
                self.lang_id = (json["home_sections3_lang_id"] as? String) ?? ""
                self.movies = [Movies]()
                if let list = json["home_sections3"] as? [[String:Any]] {
                    for each in list {
                        let movie = Movies(dict: each)
                        self.movies?.append(movie)
                    }
                }
                home.tempDict.removeValue(forKey: "home_sections3_type")
                home.tempDict.removeValue(forKey: "home_sections3_title")
                home.tempDict.removeValue(forKey: "home_sections3_lang_id")
                home.tempDict.removeValue(forKey: "home_sections3")
                return
            }
            
            if let type = json["home_sections4_type"] as? String {
                self.type = type
                
                
                if type == "Series" {
                    self.title = (json["home_sections4_title"] as? String) ?? ""
                    self.lang_id = (json["home_sections4_lang_id"] as? String) ?? ""
                    self.shows = [Shows]()
                    if let list = json["home_sections4"] as? [[String:Any]] {
                        for each in list {
                            let show = Shows(dict: each)
                            self.shows?.append(show)
                        }
                    }
                } else {
                    self.title = (json["home_sections4_title"] as? String) ?? ""
                    self.lang_id = (json["home_sections4_lang_id"] as? String) ?? ""
                    self.movies = [Movies]()
                    if let list = json["home_sections4"] as? [[String:Any]] {
                        for each in list {
                            let movie = Movies(dict: each)
                            self.movies?.append(movie)
                        }
                    }
                }
                
                
                home.tempDict.removeValue(forKey: "home_sections4_type")
                home.tempDict.removeValue(forKey: "home_sections4_title")
                home.tempDict.removeValue(forKey: "home_sections4_lang_id")
                home.tempDict.removeValue(forKey: "home_sections4")
                return
            }
            
            if let type = json["home_sections5_type"] as? String {
                self.type = type
                self.title = (json["home_sections5_title"] as? String) ?? ""
                self.lang_id = (json["home_sections5_lang_id"] as? String) ?? ""
                self.shows = [Shows]()
                if let list = json["home_sections5"] as? [[String:Any]] {
                    for each in list {
                        let show = Shows(dict: each)
                        self.shows?.append(show)
                    }
                }
                home.tempDict.removeValue(forKey: "home_sections5_type")
                home.tempDict.removeValue(forKey: "home_sections5_title")
                home.tempDict.removeValue(forKey: "home_sections5_lang_id")
                home.tempDict.removeValue(forKey: "home_sections5")
                return
            }*/
        }
    }
}



class Movies {
    var serverData : [String: Any] = [:]
    var movie_poster : String?
    var movie_title : String?
    var movie_duration : String?
    var movie_access : String?
    var movie_id : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let movie_poster = dict["movie_poster"] as? String {
            self.movie_poster = movie_poster
        }
        if let movie_title = dict["movie_title"] as? String {
            self.movie_title = movie_title
        }
        if let movie_duration = dict["movie_duration"] as? String {
            self.movie_duration = movie_duration
        }
        if let movie_access = dict["movie_access"] as? String {
            self.movie_access = movie_access
        }
        if let movie_id = dict["movie_id"] as? Int {
            self.movie_id = movie_id
        }
    }
}
class Shows {
    var serverData : [String: Any] = [:]
    var show_poster : String?
    var show_title : String?
    var show_id : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let show_poster = dict["show_poster"] as? String {
            self.show_poster = show_poster
        }
        if let show_title = dict["show_title"] as? String {
            self.show_title = show_title
        }
        if let show_id = dict["show_id"] as? Int {
            self.show_id = show_id
        }
    }
}

class RecentlyWatched {
    var serverData : [String: Any] = [:]
    var video_id : Int?
    var video_thumb_image : String?
    var video_type : String?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let video_id = dict["video_id"] as? Int {
            self.video_id = video_id
        }
        if let video_thumb_image = dict["video_thumb_image"] as? String {
            self.video_thumb_image = video_thumb_image
        }
        if let video_type = dict["video_type"] as? String {
            self.video_type = video_type
        }
    }
}


class Banner {
    var serverData : [String: Any] = [:]
    var slider_type : String?
    var slider_image : String?
    var slider_title : String?
    var slider_post_id : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let slider_type = dict["slider_type"] as? String {
            self.slider_type = slider_type
        }
        if let slider_image = dict["slider_image"] as? String {
            self.slider_image = slider_image
        }
        if let slider_title = dict["slider_title"] as? String {
            self.slider_title = slider_title
        }
        if let slider_post_id = dict["slider_post_id"] as? Int {
            self.slider_post_id = slider_post_id
        }
    }
}
