//
//  Constant.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import UIKit


var storyboardIdParam = "StoryboardIDS"
var appDetail: AppDetailIncoming.AppDetail?

let appstoreLink = "https://apps.apple.com/in/app/facebook/id284882215"

// MARK:- NOTIFICATION OBSERVER KEYS
struct NotificationKeys {
    static let kToggleMenu = NSNotification.Name(rawValue: "ToggleSideMenu")
    static let kLoadViewController = NSNotification.Name(rawValue: "LoadViewController")
}
