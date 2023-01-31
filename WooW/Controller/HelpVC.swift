//
//  HelpVC.swift
//  WooW
//
//  Created by Rahul Chopra on 30/05/21.
//

import UIKit

class HelpVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    let pickerView = UIPickerView()
    var types = ["Sign in", "Sign up", "Forgot Password or Email",
                 "Lost Mobile or Change Phone Number", "Subscription Related Issue",
                 "Suggestion", "Random Issue"]
    var selectedType: String = ""
    var isComeFromAuth: Bool = false
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeTextFromTextFields()
        self.setupPickerView()
        
        if isComeFromAuth {
            self.searchBtn.isHidden = true
            self.sideMenuBtn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
            self.sideMenuBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        }
    }
    
    func setupPickerView() {
        typeTextField.inputView = pickerView
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        if isComeFromAuth {
            self.navigationController?.popViewController(animated: true)
        } else {
            NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
        }
    }

    @IBAction func actionSearch(_ sender: UIButton) {
    }
    
    @IBAction func actionSendMailReq(_ sender: DesignableButton) {
        if nameTextField.isEmptyOrWhitespace() {
            Alert.show(message: "Please enter name")
        } else if emailTextField.isEmptyOrWhitespace() {
            Alert.show(message: "Please enter email")
        } else if phoneNumber.isEmptyOrWhitespace() {
            Alert.show(message: "Please enter phone number")
        } else if selectedType == "" {
            Alert.show(message: "Please choose issue type")
        } else if descTextView.isEmptyOrWhitespace() || descTextView.text! == "Enter Description" {
            Alert.show(message: "Please enter issue description")
        } else {
            let param = ["name": nameTextField.text.leoSafe(),
                         "email": emailTextField.text.leoSafe(),
                         "phone": phoneNumber.text.leoSafe(),
                         "type": selectedType,
                         "description": descTextView.text.leoSafe()]
            self.apiCalled(api: .help_desk, param: param)
        }
    }
}



extension HelpVC: UITextViewDelegate {
    func removeTextFromTextFields() {
        self.nameTextField.text = ""
        self.emailTextField.text = ""
        self.phoneNumber.text = ""
        self.typeTextField.text = ""
        self.descTextView.text = "Enter Description"
        self.nameTextField.placeholderColor(color: .white)
        self.emailTextField.placeholderColor(color: .white)
        self.phoneNumber.placeholderColor(color: .white)
        self.typeTextField.placeholderColor(color: .white)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Description" {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter Description"
        }
    }
}


// MARK:- API IMPLEMENTATIONS
extension HelpVC {
    func apiCalled(api: Api, param: [String:Any]) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }
        
        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: api, jsonObject: params) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            if api == .help_desk {
                if isSuccess(json: jsonDict) {
                    print(jsonDict)
                    
                    if let videoStreamArr = jsonDict["VIDEO_STREAMING_APP"] as? [[String:Any]],
                       let first = videoStreamArr.first {
                        if let msg = first["msg"] as? String, let success = first["success"] as? String {
                            if success == "1" {
                                Alert.showSimple(msg) {
                                    self.removeTextFromTextFields()
                                }
                            } else {
                                Alert.show(message: msg)
                            }
                        }
                    }
                } else {
                    Alert.showSimple("Server disconnected")
                }
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
}


//MARK:- --- PICKER VIEW DELEGATE & DATA SOURCE
extension HelpVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedType = types[row]
        typeTextField.text = types[row]
    }
}
