//
//  RazorPay.swift
//  WooW
//
//  Created by Rahul Chopra on 28/05/21.
//

import Foundation
import UIKit
//import Razorpay
//
//class RazorPay {
//
//    static let shared = RazorPay()
//    var razorpay: RazorpayCheckout?
//    let testKey = "rzp_test_bv877nH4PbvWKE"
//    var closureDidFinishPayment: ((String) -> ())?
//
//
//    func openRazorpayCheckout(key: String) {
//        // 1. Initialize razorpay object with provided key. Also depending on your requirement you can assign delegate to self. It can be one of the protocol from RazorpayPaymentCompletionProtocolWithData, RazorpayPaymentCompletionProtocol.
//        razorpay = RazorpayCheckout.initWithKey(key, andDelegate: self)
//        let options: [AnyHashable:Any] = [
//            "prefill": [
//                "contact": Cookies.userInfo()?.phone ?? "",
//                "email": Cookies.userInfo()?.email ?? ""
//            ],
//            "image": "https://pbs.twimg.com/profile_images/1271385506505347074/QIc_CCEg_400x400.jpg",
//            "amount" : 100,
//            "name": Cookies.userInfo()?.name ?? "",
//            "theme": [
//                "color": UIColor.blue.toHexString()
//            ]
//            // follow link for more options - https://razorpay.com/docs/payment-gateway/web-integration/standard/checkout-form/
//        ]
//        if let rzp = self.razorpay {
//            rzp.open(options)
//        } else {
//            print("Unable to initialize")
//        }
//    }
//}
//
//
//extension RazorPay: RazorpayPaymentCompletionProtocol {
//    func onPaymentError(_ code: Int32, description str: String) {
//        print("onPaymentError : \(str)")
//        Alert.show(message: str)
//    }
//
//    func onPaymentSuccess(_ payment_id: String) {
//        print("onPaymentSuccess : \(payment_id)")
//        self.closureDidFinishPayment!(payment_id)
//    }
//}
