//
//  UserDefault.swift
//  WooW
//
//  Created by Rahul Chopra on 03/07/21.
//

import Foundation
import UIKit

class UserDefault {
    
    class func saveSubscriptionExpiration(date: Date) {
        UserDefaults.standard.set(date, forKey: "SubscriptionExpiredDate")
    }
    
    class func isSubscriptionExpired() -> Bool {
        if let expirationDate = UserDefaults.standard.value(forKey: "SubscriptionExpiredDate") as? Date {
            if expirationDate.timeIntervalSinceNow < 0 {
                // Expired
                return true
            } else {
                // Not Expired
                return false
            }
        } else {
            return true
        }
    }
    
    class func saveLastTransactionId(transactionId: String) {
        UserDefaults.standard.set(transactionId, forKey: "LastTransactionId")
    }
    
    class func lastTransactionId() -> String {
        return UserDefaults.standard.string(forKey: "LastTransactionId") ?? ""
    }
    
    class func getLastTransactionId() -> String {
        if let transactionId = UserDefaults.standard.value(forKey: "LastTransactionId") as? String {
            return transactionId
        }
        return ""
    }
    
//    class func purchasedSubscriptionType() -> SubscriptionType {
//        if let productId = UserDefaults.standard.value(forKey: "PurchasedProductId") as? String {
//            if productId == IAPKeys.kMonthly || productId == IAPKeys.kYearly {
//                return .creativePath
//            } else if productId == IAPKeys.kProMonthly || productId == IAPKeys.kProYearly {
//                return .creativePro
//            } else {
//                return .wellBeing
//            }
//        } else {
//            return .none
//        }
//    }
}
