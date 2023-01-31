//
//  OTPVC.swift
//  WooW
//
//  Created by Rahul Chopra on 02/05/21.
//

import UIKit

class OTPVC: UIViewController {

    @IBOutlet var otpTextField: [UITextField]!
    var user: User?
    var countryCode: String = ""
    var phone: String = ""
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        for each in otpTextField {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: each)
        }
    }
    
    
    @objc func textFieldDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            if textField.tag == 0 {
                if (textField.text!.count - 1) >= 1 {
                    otpTextField[0].text = "\(textField.text?.last ?? Character(""))"
                    otpTextField[1].becomeFirstResponder()
                } else {
                    if !textField.text!.isEmpty {
                        otpTextField[1].becomeFirstResponder()
                    }
                }
                
            } else if textField.tag == 1 {
                if (textField.text!.count - 1) >= 1 {
                    otpTextField[1].text = "\(textField.text?.last ?? Character(""))"
                    otpTextField[2].becomeFirstResponder()
                } else {
                    if !textField.text!.isEmpty {
                        otpTextField[2].becomeFirstResponder()
                    } else {
                        otpTextField[0].becomeFirstResponder()
                    }
                }
            } else if textField.tag == 2 {
                if (textField.text!.count - 1) >= 1 {
                    otpTextField[2].text = "\(textField.text?.last ?? Character(""))"
                    otpTextField[3].becomeFirstResponder()
                } else {
                    if !textField.text!.isEmpty {
                        otpTextField[3].becomeFirstResponder()
                    } else {
                        otpTextField[1].becomeFirstResponder()
                    }
                }
            } else if textField.tag == 3 {
                if (textField.text!.count - 1) >= 1 {
                    otpTextField[3].text = "\(textField.text?.last ?? Character(""))"
                    otpTextField[3].becomeFirstResponder()
                } else {
                    if !textField.text!.isEmpty {
                        otpTextField[3].resignFirstResponder()
                    } else {
                        otpTextField[2].becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionResendOTP(_ sender: DesignableButton) {
        let sign = API.shared.sign()
        var param = ["salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]
        
        if self.phone != "" {
            param["phone"] = phone
            param["country_code"] = countryCode
        } else {
            param["email"] = user?.email ?? ""
        }

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
    
    @IBAction func actionSubmit(_ sender: DesignableButton) {
        let emptyTextFields = otpTextField.filter({$0.isEmptyOrWhitespace()})
        if emptyTextFields.count == 0 {
            self.view.endEditing(true)
            
            let otps = otpTextField.map({$0.text.leoSafe()}).joined()
            self.submitOTP(otp: otps)
            
        } else {
            Alert.showSimple("Please enter verification code")
        }
    }
    
    
    func submitOTP(otp: String) {
        let sign = API.shared.sign()
        let param = ["otp": otp,
                     "salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]

        print(param)
        Hud.show(message: "", view: self.view)
        WebServices.uploadDataWithUserId(url: .confirmCode, jsonObject: param, userId: user?.user_id ?? 0) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                let userInc = try JSONDecoder().decode(UserIncoming.self, from: data)
                
                if isSuccess(json: jsonDict) {
                    if let users = userInc.users, let first = users.first {
                        if isSuccess(statusCode: first.success.leoSafe(), "1") {
                            Cookies.userInfoSave(user: self.user!)
                            self.openHomeVC()
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
    
    func openHomeVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
}
