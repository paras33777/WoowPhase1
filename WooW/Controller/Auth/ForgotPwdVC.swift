//
//  ForgotPwdVC.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import UIKit

class ForgotPwdVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var emailTxtField: UITextField!
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    
    func configureTextFields() {
        emailTxtField.attributes(placeholderColor: .white)
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSend(_ sender: DesignableButton) {
        if emailTxtField.isEmpty() {
            Alert.showSimple("Please enter email address")
            return
        }
        self.emailTxtField.resignFirstResponder()
        
        let sign = API.shared.sign()
        let param = ["email": emailTxtField.text.leoSafe(),
                     "salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]

        print(param)
        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: .forgot_password, jsonObject: param) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            if isSuccess(json: jsonDict) {
                if let videoStreamArr = jsonDict["VIDEO_STREAMING_APP"] as? [[String:Any]],
                   let first = videoStreamArr.first {
                    if let msg = first["msg"] as? String, let success = first["success"] as? String {
                        if success == "1" {
                            Alert.showSimple(msg) {
//                                self.emailTxtField.text = ""
                            }
                        } else {
                            Alert.show(message: msg)
                        }
                    }
                }
            } else {
                Alert.show(message: "Please enter valid login credentials")
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    
}
