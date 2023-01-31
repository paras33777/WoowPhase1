//
//  SignInVC.swift
//  WooW
//
//  Created by Rahul Chopra on 28/04/21.
//

import CryptoKit
import UIKit
import FlagPhoneNumber

class SignInVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var countryCodeTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        
//        emailTxtField.text = "kangamrit001@gmail.com"
//        pwdTxtField.text = "Teerpsar@92"
//        emailTxtField.text = "8168225755"
    }
    
    
    func configureTextFields() {
        emailTxtField.attributes(placeholderColor: .white)
        pwdTxtField.attributes(placeholderColor: .white)
    }
    
    func moveToSignInVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSignin(_ sender: DesignableButton) {
        if emailTxtField.isEmpty() {
            Alert.showSimple("Please enter phone number")
        }
        
        let sign = API.shared.sign()
        let param = ["phone": emailTxtField.text.leoSafe(),
                     "country_code": countryCodeTxtField.text.leoSafe(),
                     "salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]

        print(param)
        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: .loginMobile, jsonObject: param) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                let user = try JSONDecoder().decode(UserIncoming.self, from: data)
                
                if isSuccess(json: jsonDict) {
                    if let users = user.users, let first = users.first {
                        if isSuccess(statusCode: first.success.leoSafe(), "1") {
                            if first.confirmation_code.leoSafe() == "" {
                                self.moveToSignInVC()
                            } else {
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC {
                                    vc.user = first
                                    vc.countryCode = self.countryCodeTxtField.text.leoSafe()
                                    vc.phone = self.emailTxtField.text.leoSafe()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        } else {
                            Alert.show(message: first.msg.leoSafe())
                        }
                    }
                } else {
                    Alert.show(message: "Please enter valid login credentials")
                }
            } catch {
                print(error)
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }

    @IBAction func actionSkip(_ sender: DesignableButton) {
        Cookies.setSkip(bool: true)
        self.moveToSignInVC()
    }
    
    @IBAction func actionForgotPwd(_ sender: DesignableButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInEmailVC") as? SignInEmailVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionSignup(_ sender: DesignableButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as? SignupVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionCountryCode(_ sender: UIButton) {
        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
//        countryCodeTxtField.displayMode = .list
        let a = FPNTextField()
        listController.setup(repository: a.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.countryCodeTxtField.text = country.phoneCode
        }
        
        present(listController, animated: true, completion: nil)
    }
    
    @IBAction func actionTroubleSignIn(_ sender: DesignableButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as? HelpVC {
            vc.isComeFromAuth = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
