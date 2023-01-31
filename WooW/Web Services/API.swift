//
//  API.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import UIKit

let baseUrl = "https://woowchannel.com/api/v1/"
//let baseUrl = "http://staging.woowchannel.com/api/v1/"
let privacyURL = "https://woowchannel.com/page/privacy-policy"
let termConditionURL = "https://woowchannel.com/page/terms-of-use"


extension Api {
    func baseURl() -> String {
        switch self {
        default :
            return baseUrl + self.rawValued()
        }
    }
}

enum Api{
    case login
    case loginMobile
    case confirmCode
    case resendotp
    case signup
    case forgot_password
    case app_details
    case home
    case show_details
    case profile
    case profile_update
    case delete_account

    case dashboard
    
    case subscription_plan
    case payment_settings
    case transaction_add
    
    case livetv_category
    case livetv_by_category
    case livetv_details
    
    case languages
    case genres
    
    case shows_by_language
    case shows_by_genre
    case episodes
    
    case movies_by_language
    case movies_by_genre
    case movie_details
    case movies_details
    
    case sports_category
    case sports_by_category
    
    case help_desk
    
    func rawValued() -> String {
        switch self {
            
        case .login:
            return  "login"
        case .loginMobile:
            return "loginMobile"
        case .confirmCode:
            return "confirmCode"
        case .resendotp:
            return "resendotp"
        case .signup:
            return "signup"
        case .forgot_password:
            return "forgot_password"
        case .delete_account:
            return "deleteaccount"
        case .app_details:
            return "app_details"
        case .home:
            return "homenew" //"home"
        case .show_details:
            return "show_details"
        case .episodes:
            return "episodes"
        case .profile:
            return "profile"
        case .profile_update:
            return "profile_update"
        case .dashboard:
            return "dashboard"
            
        case .subscription_plan:
            return "subscription_plan"
        case .payment_settings:
            return "payment_settings"
        case .transaction_add:
            return "transaction_add"
            
        case .livetv_category:
            return "livetv_category"
        case .livetv_by_category:
            return "livetv_by_category"
        case .livetv_details:
            return "livetv_details"
            
        case .languages:
            return "languages"
        case .genres:
            return "genres"
            
        case .shows_by_language:
            return "shows_by_language"
        case .shows_by_genre:
            return "shows_by_genre"
            
        case .movies_by_language:
            return "movies_by_language"
        case .movies_by_genre:
            return "movies_by_genre"
        case .movie_details:
            return "movie_details"
        case .movies_details:
            return "movies_details"
            
        case .sports_category:
            return "sports_category"
        case .sports_by_category:
            return "sports_by_category"
            
        case .help_desk:
            return "help_desk"
        }
        
    }
}


func isSuccess(json : [String : Any] , _ success : Int = 200) -> Bool{
    if let isSucess = json["success"] as? Int {
        if isSucess == success{
            return true
        }
    } else if let isSucess = json["success"] as? String {
        if isSucess == "\(success)"{
            return true
        }
    } else if let statusCode = json["status_code"] as? Int {
        if statusCode == success{
            return true
        }
    }
    return false
}

func isSuccess(statusCode: String , _ success : String = "200") -> Bool{
    if statusCode == success{
        return true
    } else if statusCode == "\(success)"{
        return true
    } else if statusCode == success{
        return true
    }
    return false
}


func message(json : [String : Any]) -> String{
    if let isSucess = json["success"] as? Int {
        if isSucess == 400{
            return json["message"] as! String
        }
    }
    if let message = json["error_msg"] as? String {
        return message
    }
    if let message = json["message"] as? String {
        return message
    }
    if let message = json["error_description"] as? String {
        return message
    }
    return ""
}



class API {
    static let shared = API()
    static private let apiKey = "viaviweb"
    var signCode = ""
    var salt = "0"
    
    func sign() -> String {
        salt = getRandomSalt()
        signCode = (API.apiKey + salt).md5
        signCode = signCode.replacingOccurrences(of: "+", with: "-")
                    .replacingOccurrences(of: "/", with: "_")
                    .replacingOccurrences(of: "=", with: "")
        print(signCode)
        return signCode
    }
    
    private func getRandomSalt() -> String {
        let randomNumber = Int.random(in: 1...900)
        salt = "\(randomNumber)"
        return "\(randomNumber)"
    }
}
