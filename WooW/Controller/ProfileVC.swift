//
//  ProfileVC.swift
//  WooW
//
//  Created by Rahul Chopra on 04/05/21.
//

import UIKit

class ProfileVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var userImgVie: RoundImageView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addTxtField: UITextField!
    @IBOutlet weak var sideBtn: UIButton!
    
    var isComeFromSideMenu: Bool = true
    var user: ProfileIncoming.User?
    var captuedImage: UIImage?
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        userImgVie.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoPicker)))
        self.sideBtn.setImage(isComeFromSideMenu ? #imageLiteral(resourceName: "side_menu_wht") : #imageLiteral(resourceName: "back"), for: .normal)
        self.showInfoOnUI()
        self.apiCalled(api: .profile, param: ["user_id": Cookies.userInfo()?.user_id ?? 0])
    }

    
    func showInfoOnUI() {
        if let userInfo = user {
            userImgVie.showImage(imgURL: userInfo.user_image.leoSafe(), placeholderImage: "dummy_user")
            nameTxtField.text = userInfo.name.leoSafe().capitalized
            emailTxtField.text = userInfo.email.leoSafe()
            phoneTxtField.text = userInfo.phone.leoSafe()
            addTxtField.text = userInfo.user_address.leoSafe()
            pwdTxtField.text = userInfo.name.leoSafe()
        } else {
            userImgVie.showImage(imgURL: Cookies.userInfo()!.user_image.leoSafe(), placeholderImage: "dummy_user")
            nameTxtField.text = Cookies.userInfo()!.name.leoSafe().capitalized
            emailTxtField.text = Cookies.userInfo()!.email.leoSafe()
            phoneTxtField.text = Cookies.userInfo()!.phone.leoSafe()
            addTxtField.text = Cookies.userInfo()!.user_address.leoSafe()
            pwdTxtField.text = Cookies.userInfo()!.name.leoSafe()
        }
    }
    
    @objc func openPhotoPicker() {
        PhotoPicker.shared.showPicker()
        PhotoPicker.shared.closureDidGetImage = { image in
            self.captuedImage = image
            self.userImgVie.image = image
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        if isComeFromSideMenu {
            NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionSave(_ sender: DesignableButton) {
        if nameTxtField.isEmptyOrWhitespace() {
            Alert.showSimple("Please enter name")
        } else if emailTxtField.isEmptyOrWhitespace() {
            Alert.showSimple("Please enter email")
        } else if phoneTxtField.isEmptyOrWhitespace() {
            Alert.showSimple("Please enter phone")
        } else if addTxtField.isEmptyOrWhitespace() {
            Alert.showSimple("Please enter address")
        } else {
            
            var params = [String:Any]()
            params["user_id"] = Cookies.userInfo()?.user_id ?? 0
            params["name"] = nameTxtField.text.leoSafe()
            params["email"] = emailTxtField.text.leoSafe()
            params["phone"] = phoneTxtField.text.leoSafe()
            params["user_address"] = addTxtField.text.leoSafe()
            if !pwdTxtField.isEmptyOrWhitespace() {
                params["password"] = pwdTxtField.text.leoSafe()
            } else {
                params["password"] = ""
            }
            
            if captuedImage != nil {
                params["user_image"] = captuedImage!.jpegData(compressionQuality: 0.1)!.base64EncodedString()
                self.uploadImage(params: params, image: captuedImage!)
            } else {
                self.apiCalled(api: .profile_update, param: params)
            }
        }
    }
    @IBAction func deleteAccountAction(_ sender: UIButton){
        showLogoutAlert()

    }
    @IBAction func actionGetPlan(_ sender: DesignableButton) {
        self.apiCalled(api: .subscription_plan, param: [:])
    }
    func openSignInVC() {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInEmailVC") as! SignInEmailVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    func showLogoutAlert() {
        Alert.show(message: "Are you sure you want to Delete your account?", actionTitle1: "Yes", actionTitle2: "No", alertStyle: .alert, completionOK: {
            self.apiCalled(api: .delete_account, param: [:])


        }, completionCancel: nil)
    }
}


// MARK:- API IMPLEMENTATIONS
extension ProfileVC {
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
        }else{
            let sign = API.shared.sign()
            params["sign"] = sign
            params["salt"] = API.shared.salt
//            params["user_id"] = Cookies.userInfo()?.user_id ?? 0
//            var params = ["sign": sign,
//                         "salt": API.shared.salt
//                        ] as [String : Any]
            for (key, value) in param {
                params[key] = value
            }
        }
   
        

        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: api, jsonObject: params, method: .post) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            if api == .profile {
                if isSuccess(json: jsonDict) {
                    if let user = ProfileIncoming(dict: jsonDict).user!.first {
                        self.user = user
                        Cookies.userInfoSave(user: User(dict: user.serverData))
                        self.showInfoOnUI()
                    }
                } else {
                    Alert.showSimple(ProfileIncoming(dict: jsonDict).user?.first?.msg ?? "")
                }
            } else if api == .profile_update {
                if isSuccess(json: jsonDict) {
                    if let user = ProfileIncoming(dict: jsonDict).user!.first {
                        self.apiCalled(api: .profile, param: ["user_id": Cookies.userInfo()?.user_id ?? 0])
                        Alert.showSimple(user.msg.leoSafe())
                    }
                } else {
                    Alert.showSimple(ProfileIncoming(dict: jsonDict).user?.first?.msg ?? "")
                }
            } else if api == .subscription_plan {
                if isSuccess(json: jsonDict) {
                    let subscription = SubscriptionPlanIncoming(dict: jsonDict)
                    let subscriptions = subscription.subscription ?? []
                    self.openSubscriptionList(subscriptions: subscriptions)
                } else {
                    Alert.showSimple("Server disconnected")
                }
            }else if api == .delete_account{
                Cookies.deleteUserInfo()
                Cookies.setSkip(bool: false)
                self.openSignInScreen()
                
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    
    func openSubscriptionList(subscriptions: [SubscriptionPlanIncoming.Subscription]) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListVC") as? SubscriptionListVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.subscriptions = subscriptions
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func uploadImage(params: [String:Any], image: UIImage) {
        WebServices.uploadDataWithImg(url: .profile_update, jsonObject: params, image: image, imageKey: "user_image") { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }

    }
}

