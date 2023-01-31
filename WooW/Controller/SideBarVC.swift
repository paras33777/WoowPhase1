//
//  SideBarVC.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import UIKit

class SideBarVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    

    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        if Cookies.userInfo() != nil {
            nameLbl.text = Cookies.userInfo()!.name.leoSafe()
            emailLbl.text = Cookies.userInfo()!.email.leoSafe()
        }
    }

}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension SideBarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cookies.userInfo() != nil ? SideBarModel.loggedinData().count : SideBarModel.data().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarCell", for: indexPath) as! SideBarCell
        if Cookies.userInfo() != nil {
            cell.configure(model: SideBarModel.loggedinData()[indexPath.row])
        } else {
            cell.configure(model: SideBarModel.data()[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
         
        let action = Cookies.userInfo() != nil ? SideBarModel.loggedinData()[indexPath.row].action : SideBarModel.data()[indexPath.row].action
        switch action {
        case .home :
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "HomeVC"])
        case .settings :
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "SettingsVC"])
        case .movies:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "MoviesVC"])
        case .dashboard:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "DashboardVC"])
        case .profile:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "ProfileVC"])
        case .tvShows:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "TVShowsVC"])
//            Alert.showSimple("Under development")
        case .sports:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "SportsVC"])
//            Alert.showSimple("Under development")
        case .liveTV:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "LiveTVVC"])
        case .help:
            NotificationCenter.default.post(name: NotificationKeys.kLoadViewController, object: nil, userInfo: [storyboardIdParam: "HelpVC"])
            
        case .login:
            self.openSignInScreen()
        case .logout:
            self.showLogoutAlert()
            
        default :
            break
        }
    }
    
//    func openSignInScreen() {
//        Cookies.setSkip(bool: false)
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.isNavigationBarHidden = true
//        UIApplication.window().rootViewController = navVC
//        UIApplication.window().makeKeyAndVisible()
//    }
    
    func showLogoutAlert() {
        Alert.show(message: "Are you sure you want to logout?", actionTitle1: "Yes", actionTitle2: "No", alertStyle: .alert, completionOK: {
            Cookies.deleteUserInfo()
            Cookies.setSkip(bool: false)
            self.openSignInScreen()
        }, completionCancel: nil)
    }
}
