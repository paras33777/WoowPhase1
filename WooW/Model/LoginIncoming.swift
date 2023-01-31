//
//  LoginIncoming.swift
//  WooW
//
//  Created by Rahul Chopra on 02/05/21.
//

import Foundation

class LoginIncoming {
    var serverData : [String: Any] = [:]
    var vIDEO_STREAMING_APP : [Video_Streaming_App]?
    
    init(dict: [String: Any]){
        self.serverData = dict
        
        if let vIDEO_STREAMING_APP = dict["VIDEO_STREAMING_APP"] as? [[String : Any]] {
            self.vIDEO_STREAMING_APP = []
            for object in vIDEO_STREAMING_APP {
                let some =  Video_Streaming_App(dict: object)
                self.vIDEO_STREAMING_APP?.append(some)
                
            }
        }
    }
    
    class Video_Streaming_App {
        var serverData : [String: Any] = [:]
        var message : String?
        var status : Int?
        init(dict: [String: Any]){
            self.serverData = dict
            
            if let message = dict["message"] as? String {
                self.message = message
            } else if let message = dict["msg"] as? String {
                self.message = message
            }
            
            if let status = dict["status"] as? Int {
                self.status = status
            } else if let success = dict["success"] as? String {
                self.status = Int(success) ?? 0
            }
        }
    }
}
