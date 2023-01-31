//
//  ShowSeasonModel.swift
//  WooW
//
//  Created by Rahul Chopra on 10/06/21.
//

import Foundation

class ShowSeasonModel {
    var serverData : [String: Any] = [:]
    var episodes = [Episode]()
    var status_code : Int?
    var total_records : Int?
    var user_plan_status : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.episodes = []
            for object in vIDEO_STREAMING_APP {
                let some = Episode(dict: object)
                self.episodes.append(some)
            }
        }
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let total_records = dict["total_records"] as? Int {
            self.total_records = total_records
        }
        if let user_plan_status = dict["user_plan_status"] as? Int {
            self.user_plan_status = user_plan_status
        }
    }
    class Episode {
        var serverData : [String: Any] = [:]
        var description : String?
        var imdb_rating : String?
        var download_url : String?
        var video_access : String?
        var subtitle_url3 : String?
        var subtitle_language1 : String?
        var series_name : String?
        var genre_list : [String]? = []
        var video_url_1080 : String?
        var video_quality : String?
        var subtitle_on_off : String?
        var download_enable : String?
        var episode_id : Int?
        var video_url : String?
        var episode_image : String?
        var language_name : String?
        var video_url_720 : String?
        var subtitle_language2 : String?
        var video_url_480 : String?
        var subtitle_url2 : String?
//        var video_type : String?
        var video_type : VideoType = .URL
        var lang_id : Int?
        var subtitle_language3 : String?
        var duration : String?
        var season_name : String?
        var subtitle_url1 : String?
        var episode_title : String?
        var release_date : String?
        var isSelected: Bool = false
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let description = dict["description"] as? String {
                self.description = description
            }
            if let imdb_rating = dict["imdb_rating"] as? String {
                self.imdb_rating = imdb_rating
            }
            if let download_url = dict["download_url"] as? String {
                self.download_url = download_url
            }
            if let video_access = dict["video_access"] as? String {
                self.video_access = video_access
            }
            if let subtitle_url3 = dict["subtitle_url3"] as? String {
                self.subtitle_url3 = subtitle_url3
            }
            if let subtitle_language1 = dict["subtitle_language1"] as? String {
                self.subtitle_language1 = subtitle_language1
            }
            if let series_name = dict["series_name"] as? String {
                self.series_name = series_name
            }
            if let genre_list = dict["genre_list"] as? [String] {
                self.genre_list = genre_list
            }
            if let video_url_1080 = dict["video_url_1080"] as? String {
                self.video_url_1080 = video_url_1080
            }
            if let video_quality = dict["video_quality"] as? String {
                self.video_quality = video_quality
            }
            if let subtitle_on_off = dict["subtitle_on_off"] as? String {
                self.subtitle_on_off = subtitle_on_off
            }
            if let download_enable = dict["download_enable"] as? String {
                self.download_enable = download_enable
            }
            if let episode_id = dict["episode_id"] as? Int {
                self.episode_id = episode_id
            }
            if let video_url = dict["video_url"] as? String {
                self.video_url = video_url
            }
            if let episode_image = dict["episode_image"] as? String {
                self.episode_image = episode_image
            }
            if let language_name = dict["language_name"] as? String {
                self.language_name = language_name
            }
            if let video_url_720 = dict["video_url_720"] as? String {
                self.video_url_720 = video_url_720
            }
            if let subtitle_language2 = dict["subtitle_language2"] as? String {
                self.subtitle_language2 = subtitle_language2
            }
            if let video_url_480 = dict["video_url_480"] as? String {
                self.video_url_480 = video_url_480
            }
            if let subtitle_url2 = dict["subtitle_url2"] as? String {
                self.subtitle_url2 = subtitle_url2
            }
            if let video_type = dict["video_type"] as? String {
                self.video_type = VideoType(rawValue: video_type.lowercased()) ?? .URL
            }
            if let lang_id = dict["lang_id"] as? Int {
                self.lang_id = lang_id
            }
            if let subtitle_language3 = dict["subtitle_language3"] as? String {
                self.subtitle_language3 = subtitle_language3
            }
            if let duration = dict["duration"] as? String {
                self.duration = duration
            }
            if let season_name = dict["season_name"] as? String {
                self.season_name = season_name
            }
            if let subtitle_url1 = dict["subtitle_url1"] as? String {
                self.subtitle_url1 = subtitle_url1
            }
            if let episode_title = dict["episode_title"] as? String {
                self.episode_title = episode_title
            }
            if let release_date = dict["release_date"] as? String {
                self.release_date = release_date
            }
        }
        class Genre_List {
            var serverData : [String] = []
            init(dict: [String]){
                self.serverData = dict
                
            }
        }
    }
}
