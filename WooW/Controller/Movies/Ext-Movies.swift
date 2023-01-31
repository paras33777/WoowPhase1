//
//  Ext-Movies.swift
//  WooW
//
//  Created by MAC on 16/05/21.
//

import Foundation
import UIKit

// MARK:- API IMPLEMENTATIONS
extension MoviesVC {
    func apiCalled(api: Api, param: [String:Any]) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }
        

        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: api, jsonObject: params, method: .post) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            if api == .languages {
                let details = LanguageIncoming(dict: jsonDict)
                if isSuccess(json: details.serverData) {
                    self.languages = details.language ?? []
                    if self.languages.count > 0 {
                        self.languages[0].isSelected = true
                        self.callListAPI(lang_id: self.languages[0].language_id.leoSafe(),
                                         filter: self.filterAction)
                    }
                    self.collectionView.reloadData()
                } else {
                    Alert.showSimple("\(details.serverData)")
                }
            } else if api == .genres {
                let details = GenreIncoming(dict: jsonDict)
                if isSuccess(json: details.serverData) {
                    self.genres = details.genres ?? []
                    if self.genres.count > 0 {
                        self.genres[0].isSelected = true
                        self.callGenreListAPI(genre_id: self.genres[0].genre_id.leoSafe(),
                                              filter: self.filterAction)
                    }
                    self.collectionView.reloadData()
                } else {
                    Alert.showSimple("\(details.serverData)")
                }
            } else if api == .movies_by_language {
                if let status_code = jsonDict["status_code"] as? Int,
                    status_code == 200{
                    if let movieVideo = jsonDict["VIDEO_STREAMING_APP"] as? [[String:Any]] {
                        var moviesModel = [Movies]()
                        for each in movieVideo {
                            let movie = Movies(dict: each)
                            moviesModel.append(movie)
                        }
                        self.movies = moviesModel
                        self.noItemView.isHidden = self.movies.count == 0 ? false : true
                        self.moviesCollectionview.reloadData()
                    }
                }
            } else if api == .movies_by_genre {
                if let status_code = jsonDict["status_code"] as? Int,
                    status_code == 200{
                    if let movieVideo = jsonDict["VIDEO_STREAMING_APP"] as? [[String:Any]] {
                        var moviesModel = [Movies]()
                        for each in movieVideo {
                            let movie = Movies(dict: each)
                            moviesModel.append(movie)
                        }
                        self.movies = moviesModel
                        self.noItemView.isHidden = self.movies.count == 0 ? false : true
                        self.moviesCollectionview.reloadData()
                    }
                }
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
}

