//
//  SideBarModel.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import Foundation
import UIKit

enum SideBarEnum {
    case home
    case tvShows
    case movies
    case sports
    case liveTV
    case dashboard
    case settings
    case login
    case profile
    case help
    case logout
}

struct SideBarModel {
    let name: String
    let image: UIImage
    let selectedImage: UIImage
    let action: SideBarEnum
    
    static func data() -> [SideBarModel] {
        var arr = [SideBarModel]()
        arr.append(SideBarModel(name: "Home", image: #imageLiteral(resourceName: "home_wht"), selectedImage: #imageLiteral(resourceName: "home_red"), action: .home))
        arr.append(SideBarModel(name: "TV Shows", image: #imageLiteral(resourceName: "tv"), selectedImage: #imageLiteral(resourceName: "tv_red"), action: .tvShows))
        arr.append(SideBarModel(name: "Movies", image: #imageLiteral(resourceName: "movie"), selectedImage: #imageLiteral(resourceName: "movie_red"), action: .movies))
        arr.append(SideBarModel(name: "Sports", image: #imageLiteral(resourceName: "sports_wht"), selectedImage: #imageLiteral(resourceName: "sports_red"), action: .sports))
        arr.append(SideBarModel(name: "Live TV", image: #imageLiteral(resourceName: "live_tv"), selectedImage: #imageLiteral(resourceName: "live_tv_red"), action: .liveTV))
        arr.append(SideBarModel(name: "Dashboard", image: #imageLiteral(resourceName: "dashboard"), selectedImage: #imageLiteral(resourceName: "dashboard_red"), action: .dashboard))
        arr.append(SideBarModel(name: "Settings", image: #imageLiteral(resourceName: "setting"), selectedImage: #imageLiteral(resourceName: "setting_red"), action: .settings))
        arr.append(SideBarModel(name: "Help", image: UIImage(named: "ic_help")!, selectedImage: UIImage(named: "ic_help")!, action: .help))
        arr.append(SideBarModel(name: "Login", image: #imageLiteral(resourceName: "login"), selectedImage: #imageLiteral(resourceName: "login_red"), action: .login))
        return arr
    }
    
    static func loggedinData() -> [SideBarModel] {
        var arr = [SideBarModel]()
        arr.append(SideBarModel(name: "Home", image: #imageLiteral(resourceName: "home_wht"), selectedImage: #imageLiteral(resourceName: "home_red"), action: .home))
        arr.append(SideBarModel(name: "TV Shows", image: #imageLiteral(resourceName: "tv"), selectedImage: #imageLiteral(resourceName: "tv_red"), action: .tvShows))
        arr.append(SideBarModel(name: "Movies", image: #imageLiteral(resourceName: "movie"), selectedImage: #imageLiteral(resourceName: "movie_red"), action: .movies))
        arr.append(SideBarModel(name: "Sports", image: #imageLiteral(resourceName: "sports_wht"), selectedImage: #imageLiteral(resourceName: "sports_red"), action: .sports))
        arr.append(SideBarModel(name: "Live TV", image: #imageLiteral(resourceName: "live_tv"), selectedImage: #imageLiteral(resourceName: "live_tv_red"), action: .liveTV))
        arr.append(SideBarModel(name: "Profile", image: #imageLiteral(resourceName: "login"), selectedImage: #imageLiteral(resourceName: "login_red"), action: .profile))
        arr.append(SideBarModel(name: "Dashboard", image: #imageLiteral(resourceName: "dashboard"), selectedImage: #imageLiteral(resourceName: "dashboard_red"), action: .dashboard))
        arr.append(SideBarModel(name: "Settings", image: #imageLiteral(resourceName: "setting"), selectedImage: #imageLiteral(resourceName: "setting_red"), action: .settings))
        arr.append(SideBarModel(name: "Help", image: UIImage(named: "ic_help")!, selectedImage: UIImage(named: "ic_help")!, action: .help))
        arr.append(SideBarModel(name: "Logout", image: #imageLiteral(resourceName: "login"), selectedImage: #imageLiteral(resourceName: "login_red"), action: .logout))
        return arr
    }
}
