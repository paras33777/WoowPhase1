//
//  AboutUsVC.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import UIKit
import SDWebImage

class AboutUsVC: UIViewController {

    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var compNameLbl: UILabel!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var compNameLbl2: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
    }
    
    func showInfoOnUI() {
        if let appDetail = appDetail {
            logoImgView.sd_setImage(with: URL(string: appDetail.app_logo.leoSafe()), placeholderImage: nil, options: [.continueInBackground])
            compNameLbl.text = appDetail.app_name.leoSafe()
            versionLbl.text = appDetail.app_version.leoSafe()
            compNameLbl2.text = appDetail.app_company.leoSafe()
            emailLbl.text = appDetail.app_email.leoSafe()
            websiteLbl.text = appDetail.app_website.leoSafe()
            
            let font = "<font face='Poppins-Medium' size='4.6' color= 'darkGray'>%@"
            let textData = String(format: font, appDetail.app_about.leoSafe()).data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                descLbl.attributedText = attText
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
