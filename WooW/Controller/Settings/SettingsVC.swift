//
//  SettingsVC.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import UIKit
import StoreKit

class SettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var show_id: Int = 13
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }
    
    // MARK:- API IMPLEMENTATIONS
    func getDetails() {
        let sign = API.shared.sign()
        let param = ["lang_id": show_id,
                     "filter": "",
                     "sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]

        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: .movies_by_language, jsonObject: param) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
//            let home = HomeListIncoming(dict: jsonDict)
//            self.bannerData = home.vIDEO_STREAMING_APP?.slider ?? []
            
            
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    func apiCalled(api: Api, param: [String:Any]) {
        var params = [String:Any]()
        if api == .delete_account{
            let sign = API.shared.sign()
            params["sign"] = sign
            params["salt"] = API.shared.salt
            params["user_id"] = Cookies.userInfo()?.user_id ?? 0

//            = ["sign": sign,
//                         "salt": API.shared.salt,
//                          "user_id": Cookies.userInfo()?.user_id ?? 0
//                        ] as [String : Any]
            for (key, value) in param {
                params[key] = value
            }
        }
   
        

        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: api, jsonObject: params, method: .post) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
             if api == .delete_account{
                Cookies.deleteUserInfo()
                Cookies.setSkip(bool: false)
                self.openSignInScreen()
                
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    func showLogoutAlert() {
        Alert.show(message: "Are you sure you want to Delete your account?", actionTitle1: "Yes", actionTitle2: "No", alertStyle: .alert, completionOK: {
            self.apiCalled(api: .delete_account, param: [:])


        }, completionCancel: nil)
    }
    
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }

}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingModel.data().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
        cell.configure(model: SettingModel.data()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SettingModel.data()[indexPath.row].action {
        case .aboutUs:
            openVC(identifier: "AboutUsVC")
        case .moreApp:
            openAppstore()
        case .privacyPolicy:
            openVC(identifier: "PrivacyPolicyVC")
        case .pushNotification:
            break
        case .rateApp:
            rateApp()
        case .shareApp:
            openActivityController()
        case .deleteAccount:
            showLogoutAlert()
        }
    }
}


extension SettingsVC {
    func openActivityController() {
        let message = "Hi, I would like to share application which is used to play tv and movies free. Please download it from Appstore Free Here \n\n\(appstoreLink)"
        let activity = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    
    func openAppstore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id284882215"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func rateApp() {
        if #available(iOS 10.3, *){
            SKStoreReviewController.requestReview()
        }
    }
    
    func openVC(identifier: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
