//
//  DashboardIncoming.swift
//  WooW
//
//  Created by MAC on 19/05/21.
//

import Foundation

class DashboardIncoming {
    var serverData : [String: Any] = [:]
    var status_code : Int?
    var dashboard : [Dashboard]?
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let status_code = dict["status_code"] as? Int {
            self.status_code = status_code
        }
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.dashboard = []
            for object in vIDEO_STREAMING_APP {
                let some = Dashboard(dict: object)
                self.dashboard?.append(some)
                
            }
        }
    }
    class Dashboard {
        var serverData : [String: Any] = [:]
        var email : String?
        var user_id : Int?
        var last_invoice_plan : String?
        var success : String?
        var user_image : String?
        var name : String?
        var msg : String?
        var expires_on : String?
        var last_invoice_amount : String?
        var current_plan : String?
        var last_invoice_date : String?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let email = dict["email"] as? String {
                self.email = email
            }
            if let user_id = dict["user_id"] as? Int {
                self.user_id = user_id
            }
            if let last_invoice_plan = dict["last_invoice_plan"] as? String {
                self.last_invoice_plan = last_invoice_plan
            }
            if let success = dict["success"] as? String {
                self.success = success
            }
            if let user_image = dict["user_image"] as? String {
                self.user_image = user_image
            }
            if let name = dict["name"] as? String {
                self.name = name
            }
            if let msg = dict["msg"] as? String {
                self.msg = msg
            }
            if let expires_on = dict["expires_on"] as? String {
                self.expires_on = expires_on
            }
            if let last_invoice_amount = dict["last_invoice_amount"] as? String {
                self.last_invoice_amount = last_invoice_amount
            }
            if let current_plan = dict["current_plan"] as? String {
                self.current_plan = current_plan
            }
            if let last_invoice_date = dict["last_invoice_date"] as? String {
                self.last_invoice_date = last_invoice_date
            }
        }
    }
}
