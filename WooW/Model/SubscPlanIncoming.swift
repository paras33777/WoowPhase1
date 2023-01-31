//
//  SubscPlanIncoming.swift
//  WooW
//
//  Created by MAC on 19/05/21.
//

import Foundation
import StoreKit

class SubscriptionPlanIncoming {
    var serverData : [String: Any] = [:]
    var subscription : [Subscription]?
    var status_code : Int?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.subscription = []
            for object in vIDEO_STREAMING_APP {
                let some =  Subscription(dict: object)
                self.subscription?.append(some)
                
            }
        }
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
    }
    class Subscription {
        var serverData : [String: Any] = [:]
        var plan_name : String?
        var plan_price : String?
        var plan_id : Int?
        var currency_code : String?
        var plan_duration : String?
        var product: SKProduct?
        var isSelected: Bool = false
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let plan_name = dict["plan_name"] as? String {
                self.plan_name = plan_name
            }
            if let plan_price = dict["plan_price"] as? String {
                self.plan_price = plan_price
            }
            if let plan_id = dict["plan_id"] as? Int {
                self.plan_id = plan_id
            }
            if let currency_code = dict["currency_code"] as? String {
                self.currency_code = currency_code
            }
            if let plan_duration = dict["plan_duration"] as? String {
                self.plan_duration = plan_duration
            }
        }
    }
}
