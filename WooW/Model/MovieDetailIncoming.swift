//
//  MovieDetailIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 24/05/21.
//

import Foundation
import UIKit

enum VideoType: String {
    case URL = "url"
    case EMBED = "embed"
}

class MovieDetailIncoming {
    var serverData : [String: Any] = [:]
    var movie : Movie?
    var user_plan_status : Int?
    var status_code : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let object = dict["VIDEO_STREAMING_APP"] as? [String : Any] {
            let some =  Movie(dict: object)
            self.movie = some }
        if let user_plan_status = dict["user_plan_status"] as? Int {
            self.user_plan_status = user_plan_status
        }
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
    }
    class Movie {
        var serverData : [String: Any] = [:]
        var release_date : String?
        var description : String?
        var subtitle_url2 : String?
        var download_enable : String?
        var language_name : String?
        var subtitle_language1 : String?
        var related_movies : [Movies]?
        var lang_id : Int?
        var video_url_480 : String?
        var movie_image : String?
        var video_url_1080 : String?
        var video_url : String?
        var movie_title : String?
        var subtitle_language3 : String?
        var genre_list : [Genre_List]?
        var subtitle_on_off : String?
        var subtitle_language2 : String?
        var download_url : String?
        var subtitle_url3 : String?
        var movie_id : Int?
        var subtitle_url1 : String?
        var movie_access : String?
        var imdb_rating : String?
        var video_type : VideoType = .URL
        var video_quality : String?
        var movie_duration : String?
        var video_url_720 : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let release_date = dict["release_date"] as? String {
                self.release_date = release_date
            }
            if let description = dict["description"] as? String {
                self.description = description
            }
            if let subtitle_url2 = dict["subtitle_url2"] as? String {
                self.subtitle_url2 = subtitle_url2
            }
            if let download_enable = dict["download_enable"] as? String {
                self.download_enable = download_enable
            }
            if let language_name = dict["language_name"] as? String {
                self.language_name = language_name
            }
            if let subtitle_language1 = dict["subtitle_language1"] as? String {
                self.subtitle_language1 = subtitle_language1
            }
            if let related_movies = dict["related_movies"] as? [[String : Any]] {
                self.related_movies = []
                for object in related_movies {
                    let some =  Movies(dict: object)
                    self.related_movies?.append(some)
                    
                }
            }
            if let lang_id = dict["lang_id"] as? Int {
                self.lang_id = lang_id
            }
            if let video_url_480 = dict["video_url_480"] as? String {
                self.video_url_480 = video_url_480
            }
            if let movie_image = dict["movie_image"] as? String {
                self.movie_image = movie_image
            }
            if let video_url_1080 = dict["video_url_1080"] as? String {
                self.video_url_1080 = video_url_1080
            }
            if let video_url = dict["video_url"] as? String {
                self.video_url = video_url
            }
            if let movie_title = dict["movie_title"] as? String {
                self.movie_title = movie_title
            }
            if let subtitle_language3 = dict["subtitle_language3"] as? String {
                self.subtitle_language3 = subtitle_language3
            }
            if let genre_list = dict["genre_list"] as? [[String : Any]] {
                self.genre_list = []
                for object in genre_list {
                    let some =  Genre_List(dict: object)
                    self.genre_list?.append(some)
                    
                }
            }
            if let subtitle_on_off = dict["subtitle_on_off"] as? String {
                self.subtitle_on_off = subtitle_on_off
            }
            if let subtitle_language2 = dict["subtitle_language2"] as? String {
                self.subtitle_language2 = subtitle_language2
            }
            if let download_url = dict["download_url"] as? String {
                self.download_url = download_url
            }
            if let subtitle_url3 = dict["subtitle_url3"] as? String {
                self.subtitle_url3 = subtitle_url3
            }
            if let movie_id = dict["movie_id"] as? Int {
                self.movie_id = movie_id
            }
            if let subtitle_url1 = dict["subtitle_url1"] as? String {
                self.subtitle_url1 = subtitle_url1
            }
            if let movie_access = dict["movie_access"] as? String {
                self.movie_access = movie_access
            }
            if let imdb_rating = dict["imdb_rating"] as? String {
                self.imdb_rating = imdb_rating
            }
            if let video_type = dict["video_type"] as? String {
                self.video_type = VideoType(rawValue: video_type.lowercased()) ?? .URL
            }
            if let video_quality = dict["video_quality"] as? String {
                self.video_quality = video_quality
            }
            if let movie_duration = dict["movie_duration"] as? String {
                self.movie_duration = movie_duration
            }
            if let video_url_720 = dict["video_url_720"] as? String {
                self.video_url_720 = video_url_720
            }
        }
        class Related_Movies {
            var serverData : [String: Any] = [:]
            var movie_access : String?
            var movie_duration : String?
            var movie_id : Int?
            var movie_title : String?
            var movie_poster : String?
            init(dict: [String: Any]){
                self.serverData = dict
                
                if let movie_access = dict["movie_access"] as? String {
                    self.movie_access = movie_access
                }
                if let movie_duration = dict["movie_duration"] as? String {
                    self.movie_duration = movie_duration
                }
                if let movie_id = dict["movie_id"] as? Int {
                    self.movie_id = movie_id
                }
                if let movie_title = dict["movie_title"] as? String {
                    self.movie_title = movie_title
                }
                if let movie_poster = dict["movie_poster"] as? String {
                    self.movie_poster = movie_poster
                }
            }
        }
        class Genre_List {
            var serverData : [String: Any] = [:]
            var genre_id : String?
            var genre_name : String?
            init(dict: [String: Any]){
                self.serverData = dict
                
                if let genre_id = dict["genre_id"] as? String {
                    self.genre_id = genre_id
                }
                if let genre_name = dict["genre_name"] as? String {
                    self.genre_name = genre_name
                }
            }
        }
    }
}
