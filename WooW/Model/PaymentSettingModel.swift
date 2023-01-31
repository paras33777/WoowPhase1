//
//  PaymentSettingModel.swift
//  WooW
//
//  Created by Rahul Chopra on 28/05/21.
//

import Foundation

enum PostType: String {
    case movies = "Movies"
    case shows = "Shows"
    case sport = "Sport"
    case liveTV = "LiveTV"
}

class PaymentSettingIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var payment : [Payment]?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.payment = []
            for object in vIDEO_STREAMING_APP {
                let some =  Payment(dict: object)
                self.payment?.append(some)
                
            }
        }
    }
    class Payment {
        var serverData : [String: Any] = [:]
        var paypal_client_id : String?
        var paystack_public_key : Any?
        var paypal_secret : String?
        var currency_code : String?
        var stripe_publishable_key : String?
        var paypal_mode : String?
        var paystack_payment_on_off : String?
        var stripe_secret_key : String?
        var paypal_payment_on_off : String?
        var paystack_secret_key : Any?
        var razorpay_secret : String?
        var razorpay_payment_on_off : String?
        var razorpay_key : String?
        var success : String?
        var stripe_payment_on_off : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let paypal_client_id = dict["paypal_client_id"] as? String {
                self.paypal_client_id = paypal_client_id
            }
            if let paypal_secret = dict["paypal_secret"] as? String {
                self.paypal_secret = paypal_secret
            }
            if let currency_code = dict["currency_code"] as? String {
                self.currency_code = currency_code
            }
            if let stripe_publishable_key = dict["stripe_publishable_key"] as? String {
                self.stripe_publishable_key = stripe_publishable_key
            }
            if let paypal_mode = dict["paypal_mode"] as? String {
                self.paypal_mode = paypal_mode
            }
            if let paystack_payment_on_off = dict["paystack_payment_on_off"] as? String {
                self.paystack_payment_on_off = paystack_payment_on_off
            }
            if let stripe_secret_key = dict["stripe_secret_key"] as? String {
                self.stripe_secret_key = stripe_secret_key
            }
            if let paypal_payment_on_off = dict["paypal_payment_on_off"] as? String {
                self.paypal_payment_on_off = paypal_payment_on_off
            }
            if let razorpay_secret = dict["razorpay_secret"] as? String {
                self.razorpay_secret = razorpay_secret
            }
            if let razorpay_payment_on_off = dict["razorpay_payment_on_off"] as? String {
                self.razorpay_payment_on_off = razorpay_payment_on_off
            }
            if let razorpay_key = dict["razorpay_key"] as? String {
                self.razorpay_key = razorpay_key
            }
            if let success = dict["success"] as? String {
                self.success = success
            }
            if let stripe_payment_on_off = dict["stripe_payment_on_off"] as? String {
                self.stripe_payment_on_off = stripe_payment_on_off
            }
        }
    }
}
