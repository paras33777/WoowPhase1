//
//  SignInEmailVC.swift
//  WooW
//
//  Created by Rahul Chopra on 11/05/21.
//

import Foundation
import CryptoKit
import UIKit
import FlagPhoneNumber

class SignInEmailVC: UIViewController {
    
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
            Alert.showSimple("Please enter email address")
        } else if !emailTxtField.isValidEmailAddress() {
            Alert.showSimple("Please enter valid email address")
        } else if pwdTxtField.isEmpty() {
            Alert.showSimple("Please enter password")
        }
        
        let sign = API.shared.sign()
        let param = ["email": emailTxtField.text ?? "",
                     "password": pwdTxtField.text ?? "",
                     "salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]

        print(param)
        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: .login, jsonObject: param) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                let user = try JSONDecoder().decode(UserIncoming.self, from: data)
                
                if isSuccess(json: jsonDict) {
                    if let users = user.users, let first = users.first {
                        if isSuccess(statusCode: first.success.leoSafe(), "1") {
                            let msg = "We advise you to verify your number by visiting Profile Section from the side bar. In case any problem occur, contact support."
                            Alert.show(message: msg, completionOK: ({
                                Cookies.userInfoSave(user: first)
                                self.moveToSignInVC()
                            }))
                            
                            /*if first.confirmation_code.leoSafe() == "" {
                                Cookies.userInfoSave(user: first)
                                self.moveToSignInVC()
                            } else {
                                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC {
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }*/
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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPwdVC") as? ForgotPwdVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionSignup(_ sender: DesignableButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as? SignupVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionTroubleSignIn(_ sender: DesignableButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as? HelpVC {
            vc.isComeFromAuth = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
