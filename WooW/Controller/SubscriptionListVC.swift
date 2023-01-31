//
//  SubscriptionListVC.swift
//  WooW
//
//  Created by Rahul Chopra on 09/05/21.
//

import UIKit
import SafariServices

class SubscriptionListVC: UIViewController, UITextViewDelegate {
    
    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var termsLbl: UITextView!
    var subscriptions = [SubscriptionPlanIncoming.Subscription]()
    var postId: Int = 0
    var postType: PostType = .movies
    var cameVC: UIViewController?
    var closureDidRefresh: (() -> ())?
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        #if targetEnvironment(simulator)
//
//        #else
//        self.checkTransaction()
//        #endif
        self.checkTransaction()
        
//        termsLbl.typingAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 15.0)!]
        let attributedString = NSMutableAttributedString(string: "Full details can be found on our terms & condition and privacy policy page.")
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 0, length: 33))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: 33, length: 17))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 51, length: 4))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], range: NSRange(location: 55, length: 14))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], range: NSRange(location: 70, length: 5))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 14.0)!], range: NSRange(location: 0, length: 75))
        
        attributedString.addAttribute(.link, value: termConditionURL, range: NSRange(location: 34, length: 17))
        attributedString.addAttribute(.link, value: privacyURL, range: NSRange(location: 56, length: 14))
        termsLbl.attributedText = attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == privacyURL {
            let vc = SFSafariViewController(url: URL)
            present(vc, animated: true, completion: nil)
        } else if URL.absoluteString == termConditionURL {
            let vc = SFSafariViewController(url: URL)
            present(vc, animated: true, completion: nil)
        }
        return true
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionDismiss(_ sender: DesignableButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionProceed(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionDetailVC") as? SubscriptionDetailVC {
            let selectedSubscription = subscriptions.filter({$0.isSelected == true}).first!
            vc.subscription = selectedSubscription
            vc.postId = postId
            vc.postType = postType
            vc.cameVC = cameVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func actionRestore(_ sender: UIButton) {
        Hud.show(message: "Processing...", view: self.view)
        ReceiptValidator.sharedInstance.checkReceiptValidation { (isExpired, prodId,transId,purchaseDate)  in
            if let isExpired = isExpired {
                if isExpired {
                    DispatchQueue.main.async {
                        Hud.hide(view: self.view)
                        Alert.showSimple("Your subscription has expired, please subscribe") {}
                    }
                } else {
                    DispatchQueue.main.async {
                        Hud.hide(view: self.view)
                        Alert.show(message: "You already purchased subscription")
                    }
                }
            }
        }
    }
}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension SubscriptionListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTableCell", for: indexPath) as! SubscriptionTableCell
        cell.configure(index: indexPath.row, subscription: subscriptions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subscriptions.forEach({$0.isSelected = false})
        subscriptions[indexPath.row].isSelected = true
        self.tableView.reloadData()
//        if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionTableCell {
//            cell.cornerView.backgroundColor = .white
//            cell.cornerView.borderColor = UIColor.rgb(red: 233, green: 63, blue: 51)
//            cell.radioImgView.image = #imageLiteral(resourceName: "radio-fill")
//            cell.priceLbl.textColor = UIColor.rgb(red: 64, green: 64, blue: 64)
//            cell.currencyLbl.textColor = UIColor.rgb(red: 76, green: 76, blue: 76)
//            cell.durationLbl.textColor = UIColor.rgb(red: 233, green: 63, blue: 51)
//            cell.planLbl.textColor = UIColor.rgb(red: 76, green: 76, blue: 76)
//        }
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        subscriptions[indexPath.row].isSelected = false
//        if let cell = tableView.cellForRow(at: indexPath) as? SubscriptionTableCell {
//            cell.cornerView.backgroundColor = UIColor.rgb(red: 76, green: 76, blue: 76)
//            cell.cornerView.borderColor = .clear
//            cell.radioImgView.image = #imageLiteral(resourceName: "radio-unfill")
//            cell.priceLbl.textColor = .white
//            cell.currencyLbl.textColor = .white
//            cell.durationLbl.textColor = UIColor.rgb(red: 171, green: 171, blue: 171)
//            cell.planLbl.textColor = UIColor.rgb(red: 202, green: 202, blue: 202)
//        }
//    }
}


// MARK:- IAP HANDLING
extension SubscriptionListVC {
    func checkTransaction() {
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
                }
            }
        .withDidReceiveProducts {
            print("*****PRODUCTS RECEIVED*******")
            DispatchQueue.main.async {
                self.updatePackagaes()
                Hud.hide(view: self.view)
            }
        }
        
        .withDidUpdatedTransactions({ (transacation) in
            
            switch transacation.transactionState {
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                print(transacation.transactionIdentifier)
                self.callPurchaseTransactionAPI(trans_id: transacation.transactionIdentifier ?? "",
                                                trans_date: transacation.transactionDate!)
                
            case .failed:
                print("failed")
                Hud.hide(view: self.view)
                NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
                Alert.showSimple("Transaction Failed!")
                
            case .restored:
                print("restored")
                Hud.hide(view: self.view)
                NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
                
            case .deferred:
                print("deferred")
                NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
            @unknown default:
                print("")
            }
            
        }).fullStop()
    }
    
    func updatePackagaes() {
        let firstIndex = subscriptions.firstIndex(where: {$0.plan_id == 1})
        if firstIndex != nil {
            subscriptions[firstIndex!].product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kMonthly})[0]
        }
        
        let secondIndex = subscriptions.firstIndex(where: {$0.plan_id == 4})
        if secondIndex != nil {
            subscriptions[secondIndex!].product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kHalfYearly})[0]
        }
        
        let thirdIndex = subscriptions.firstIndex(where: {$0.plan_id == 2})
        if thirdIndex != nil {
            subscriptions[thirdIndex!].product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kYearly})[0]
        }
        self.tableView.reloadData()
    }
    
    func callPurchaseTransactionAPI(trans_id: String, trans_date: Date) {
        let selectedSubscription = subscriptions.filter({$0.isSelected == true}).first!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        let dateStr = dateFormatter.string(from: trans_date)
        let date = dateFormatter.date(from: dateStr)
        dateFormatter.dateFormat = "MMMM,  dd, yyyy"
        let tranDateStr = dateFormatter.string(from: date!)
        
        var params = [String:Any]()
        params["user_id"] = Cookies.userInfo()!.user_id ?? 0
        params["plan_id"] = selectedSubscription.plan_id ?? 0
        params["payment_id"] = trans_id
        params["payment_gateway"] = "RazorPay"
        params["postId"] = postId
        params["postType"] = postType.rawValue
        params["transaction_date"] = tranDateStr
        self.apiCalled(api: .transaction_add, param: params)
    }
    
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
            NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
            print(jsonDict)
            
            if api == .transaction_add {
                if isSuccess(json: jsonDict) {
                    print(jsonDict)
                    
                    if self.closureDidRefresh != nil {
                        self.closureDidRefresh!()
                    }
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
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
}
