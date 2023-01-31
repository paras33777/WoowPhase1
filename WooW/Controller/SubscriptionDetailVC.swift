//
//  SubscriptionDetailVC.swift
//  WooW
//
//  Created by MAC on 21/05/21.
//

import Foundation
import  UIKit

class SubscriptionDetailVC:  UIViewController  {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var currencyCodeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userInfiPlanLbl: UILabel!
    @IBOutlet weak var logoutLbl: UILabel!
    var subscription: SubscriptionPlanIncoming.Subscription?
    var paymentSetting: PaymentSettingIncoming.Payment?
    var postId: Int = 0
    var postType: PostType = .movies
    var cameVC: UIViewController?
    
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(iapObserver(notification:)), name: NSNotification.Name("IAPObserver"), object: nil)
    }
    
    @objc func iapObserver(notification: NSNotification) {
        if let object = notification.object as? Int {
            if object == 1 {
                Hud.hide(view: self.view)
            }
        }
    }
    
    func showInfo() {
        priceLbl.text = subscription?.product!.localizedPrice //subscription?.plan_price.leoSafe()
        currencyCodeLbl.text = subscription?.product?.priceLocale.currencyCode ?? ""
        durationLbl.text = subscription?.plan_duration.leoSafe()
        planLbl.text = subscription!.plan_name.leoSafe()
        userInfiPlanLbl.text = subscription!.plan_name.leoSafe()
        emailLbl.text = Cookies.userInfo() == nil ? " " : Cookies.userInfo()!.email.leoSafe()
    }
    
    func openLoginVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInEmailVC") as! SignInEmailVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionClose(_ sender: DesignableButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChangePlan(_ sender: DesignableButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionProceedToPay(_ sender: UIButton) {
//        self.apiCalled(api: .payment_settings, param: [:])
        if Cookies.userInfo() == nil {
            Alert.show(message: "You are not currently logged in. Please login.", completionOK: ({
                self.openLoginVC()
            }))
        } else {
            let message = "• Payment will be charged to iTunes Account at confirmation of purchase\n• Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period'\n• Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal\n• Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user’s Account Settings after purchase\n• Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable."
            let alert = UIAlertController(title: "Woow : Movie, TV Show, Web Series", message: message, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Confirm", style: .default) { (_) in
                Hud.show(message: "Purchasing...", view: self.view)
                RCInAppPurchase.shared.actionBuyProduct(self.subscription!.product!)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(actionOk)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK:- API IMPLEMENTATIONS
extension SubscriptionDetailVC {
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
            
            if api == .transaction_add {
                if isSuccess(json: jsonDict) {
                    print(jsonDict)
                    
                    Alert.show(message: "Payment Succeeded") {
                        if self.cameVC != nil {
                            self.moveToSpecificVC(vc: self.cameVC!)
                        } else {
                            self.moveToSpecificVC(vc: DashboardVC())
                        }
                    }
                } else {
                    Alert.showSimple("Server disconnected")
                }
            } else if api == .payment_settings {
                if isSuccess(json: jsonDict) {
                    
                    if let payment = PaymentSettingIncoming(dict: jsonDict).payment,
                       let first = payment.first {
                        self.paymentSetting = first
                        self.openRazorPay(key: first.razorpay_key.leoSafe())
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
    
    func openRazorPay(key: String) {
//        RazorPay.shared.openRazorpayCheckout(key: key)
//        RazorPay.shared.closureDidFinishPayment = { paymentId in
//            self.callPurchaseTransactionAPI(payment_id: paymentId)
//        }
    }
    
    func callPurchaseTransactionAPI(payment_id: String) {
        var params = [String:Any]()
        params["user_id"] = Cookies.userInfo()!.user_id ?? 0
        params["plan_id"] = subscription?.plan_id ?? 0
        params["payment_id"] = payment_id
        params["payment_gateway"] = "RazorPay"
        params["postId"] = postId
        params["postType"] = postType.rawValue
        self.apiCalled(api: .transaction_add, param: params)
    }
}

