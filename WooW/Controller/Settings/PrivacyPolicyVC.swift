//
//  PrivacyPolicyVC.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import UIKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDetail = appDetail {
            let font = "<font face='Poppins-Medium' size='4.5' color= 'white'>%@"
            let textData = String(format: font, appDetail.app_privacy.leoSafe()).data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                textView.attributedText = attText
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
