//
//  SignupVC.swift
//  WooW
//
//  Created by Rahul Chopra on 28/04/21.
//

import UIKit
import FlagPhoneNumber

class SignupVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var countryCodeTextField: UITextField!
    
    // MARK:- PROPERTIES
    var isTicked: Bool = false
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        
//        nameTextField.text = "Rahul Chopra"
//        emailTextField.text = "rahulchops93@gmail.com"
//        phoneTextField.text = "8168225755"
//        pwdTextField.text = "qwerty"
//        confirmPwdTextField.text = "qwerty"
    }

    
    func configureTextFields() {
        nameTextField.attributes(placeholderColor: .white)
        emailTextField.attributes(placeholderColor: .white)
        phoneTextField.attributes(placeholderColor: .white)
        pwdTextField.attributes(placeholderColor: .white)
        confirmPwdTextField.attributes(placeholderColor: .white)
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionAgreeTo(_ sender: UIButton) {
        isTicked = !isTicked
        checkBtn.setImage(isTicked == true ? #imageLiteral(resourceName: "checkbox") : #imageLiteral(resourceName: "untick"), for: .normal)
        checkBtn.imageEdgeInsets = isTicked ? UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func actionTroubleSignuo(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpVC") as? HelpVC {
            vc.isComeFromAuth = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionRegister(_ sender: DesignableButton) {
        if nameTextField.isEmpty() {
            Alert.showSimple("Please enter name")
        } else if emailTextField.isEmpty() {
            Alert.showSimple("Please enter email address")
        } else if !emailTextField.isValidEmailAddress() {
            Alert.showSimple("Please enter valid email address")
        } else if phoneTextField.isEmpty() {
            Alert.showSimple("Please enter phone number")
        } else if pwdTextField.isEmpty() {
            Alert.showSimple("Please enter password")
        } else if confirmPwdTextField.isEmpty() {
            Alert.showSimple("Please enter confirm password")
        } else if pwdTextField.text.leoSafe() != confirmPwdTextField.text.leoSafe() {
            Alert.showSimple("Password and confirm password not matched")
        } else if !isTicked {
            Alert.showSimple("Please agree to our terms and conditions")
        } else {
            var params = [String:Any]()
            params["name"] = nameTextField.text.leoSafe()
            params["email"] = emailTextField.text.leoSafe()
            params["password"] = pwdTextField.text.leoSafe()
            params["phone"] = phoneTextField.text.leoSafe()
            params["country_code"] = countryCodeTextField.text.leoSafe()
            params["sign"] = API.shared.sign()
            params["salt"] = API.shared.salt
            print(params)
            
            Hud.show(message: "", view: self.view)
            WebServices.uploadData(url: .signup, jsonObject: params) { (jsonDict) in
                Hud.hide(view: self.view)
                print(jsonDict)
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                    let user = try JSONDecoder().decode(UserIncoming.self, from: data)
                    
                    if isSuccess(json: jsonDict) {
                        if let users = user.users, let first = users.first {
                            
                            let msg = "We advise you to verify your number by visiting Profile Section from the side bar. In case any problem occur, contact support."
                            Alert.show(message: msg, completionOK: ({
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
                                let navVC = UINavigationController(rootViewController: vc)
                                navVC.isNavigationBarHidden = true
                                UIApplication.window().rootViewController = navVC
                                UIApplication.window().makeKeyAndVisible()
                            }))
                            
                            /*if isSuccess(statusCode: first.success.leoSafe(), "1") {
                                if first.confirmation_code.leoSafe() == "" {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
                                    let navVC = UINavigationController(rootViewController: vc)
                                    navVC.isNavigationBarHidden = true
                                    UIApplication.window().rootViewController = navVC
                                    UIApplication.window().makeKeyAndVisible()
                                } else {
                                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC {
                                        vc.user = first
                                        vc.phone = self.countryCodeTextField.text.leoSafe() + self.phoneTextField.text.leoSafe()
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            } else {
                                Alert.show(message: first.msg.leoSafe())
                            }*/
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
    }
    
    @IBAction func actionAlreadyHaveAccount(_ sender: DesignableButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCountryCode(_ sender: UIButton) {
        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
        let a = FPNTextField()
        listController.setup(repository: a.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.countryCodeTextField.text = country.phoneCode
        }
        present(listController, animated: true, completion: nil)
    }
}
