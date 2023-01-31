//
//  DashboardVC.swift
//  WooW
//
//  Created by Rahul Chopra on 09/05/21.
//

import UIKit
import StoreKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var userImgView: RoundImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var planLbl: UILabel!
    @IBOutlet weak var subsExpLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var lastInvPlanLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    
    var dashboard: DashboardIncoming.Dashboard?
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
        
//        #if targetEnvironment(simulator)
//            self.callDashboardAPI()
//        #else
//
//        #endif
        self.observeIAP()
        
    }
    
    func callDashboardAPI() {
        self.apiCalled(api: .dashboard, param: ["user_id": Cookies.userInfo()?.user_id ?? 0])
    }
    
    func showInfoOnUI() {
        nameLbl.text = "User"
        emailLbl.text = "xyz@gmail.com"
        planLbl.text = " "
        subsExpLbl.text = "Subscription expires on : "
        dateLbl.text = " "
        amountLbl.text = "$0"
        lastInvPlanLbl.text = " "
        
        if let dashboard = dashboard {
            userImgView.showImage(imgURL: dashboard.user_image.leoSafe(), placeholderImage: "dummy_user")
            nameLbl.text = dashboard.name.leoSafe().capitalized
            emailLbl.text = dashboard.email.leoSafe()
            planLbl.text = dashboard.current_plan.leoSafe()
            subsExpLbl.text = dashboard.expires_on.leoSafe() == "" ? "Subscription expires on : " : "Subscription expires on : \(dashboard.expires_on.leoSafe())"
            dateLbl.text = dashboard.last_invoice_date.leoSafe()
            lastInvPlanLbl.text = dashboard.last_invoice_plan.leoSafe()
            
            var product : SKProduct?
            if dashboard.current_plan.leoSafe() == "Monthly Plan" {
                product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kMonthly})[0]
            } else if dashboard.current_plan.leoSafe() == "Six Month Plan" {
                product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kHalfYearly})[0]
            } else {
//                product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kYearly})[0]
                
                if RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kYearly}).count > 0 {
                    product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kYearly})[0]
                } else {
                    
                }
            }
            
            if dashboard.current_plan.leoSafe() != "" {
                amountLbl.text = product == nil ? dashboard.last_invoice_amount.leoSafe() : product?.localizedPrice
            } else {
                amountLbl.text = " "
            }
            
        } else {
            if let userInfo = Cookies.userInfo() {
                userImgView.showImage(imgURL: userInfo.user_image.leoSafe(), placeholderImage: "dummy_user")
                nameLbl.text = userInfo.name.leoSafe().capitalized
                emailLbl.text = userInfo.email.leoSafe()
            }
        }
    }
    
    func openLoginVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInEmailVC") as! SignInEmailVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }

    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }
    
    @IBAction func actionEditProfile(_ sender: DesignableButton) {
        if Cookies.userInfo() == nil {
            openLoginVC()
        } else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC {
                vc.isComeFromSideMenu = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func actionUpgradePlan(_ sender: DesignableButton) {
        self.apiCalled(api: .subscription_plan, param: [:])
    }
}


// MARK:- API IMPLEMENTATIONS
extension DashboardVC {
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
            
            if api == .dashboard {
                if isSuccess(json: jsonDict) {
                    let dash = DashboardIncoming(dict: jsonDict)
                    if let dashb = dash.dashboard, let first = dashb.first {
                        self.dashboard = first
                        self.showInfoOnUI()
                    }
                } else {
                    Alert.showSimple("Server disconnected")
                }
            } else if api == .subscription_plan {
                if isSuccess(json: jsonDict) {
                    let subscription = SubscriptionPlanIncoming(dict: jsonDict)
                    let subscriptions = subscription.subscription ?? []
                    self.openSubscriptionList(subscriptions: subscriptions)
                } else {
                    Alert.showSimple("Server disconnected")
                }
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    
    func openSubscriptionList(subscriptions: [SubscriptionPlanIncoming.Subscription]) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListVC") as? SubscriptionListVC {
            vc.modalPresentationStyle = .overFullScreen
            subscriptions[0].isSelected = true
            vc.subscriptions = subscriptions
            vc.closureDidRefresh = {
                self.callDashboardAPI()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK:- IAP HANDLING
extension DashboardVC {
    func observeIAP() {
        Hud.show(message: "Processing...", view: self.view)
        RCInAppPurchase.shared
            .withAppendProductId(IAPKeys.kMonthly)
            .withAppendProductId(IAPKeys.kHalfYearly)
            .withAppendProductId(IAPKeys.kYearly)
            .actionRequestProductInfo()
            .withClosureInvalidProductIdentifiers { (error) in
                print("Invalid Product Identifier : \(error)")
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
                    self.callDashboardAPI()
                }
            }
        .withDidReceiveProducts {
            print("*****PRODUCTS RECEIVED*******")
            DispatchQueue.main.async {
                Hud.hide(view: self.view)
                self.callDashboardAPI()
            }
        }
        
        .withDidUpdatedTransactions({ (transacation) in
            
            switch transacation.transactionState {
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                print(transacation.transactionIdentifier)
                
            case .failed:
                print("failed")
                Hud.hide(view: self.view)
                Alert.showSimple("Transaction Failed!")
                
            case .restored:
                print("restored")
                Hud.hide(view: self.view)
                
            case .deferred:
                print("deferred")
            @unknown default:
                print("")
            }
            
        }).fullStop()
    }
}
