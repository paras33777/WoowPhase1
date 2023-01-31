//
//  SettingModel.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import Foundation
import UIKit

enum SettingEnum {
    case pushNotification
    case aboutUs
    case privacyPolicy
    case rateApp
    case shareApp
    case moreApp
    case deleteAccount

}

struct SettingModel {
    let name: String
    let isSwitch: Bool
    let action: SettingEnum
    
    static func data() -> [SettingModel] {
        var arr = [SettingModel]()
        arr.append(SettingModel(name: "Enable Push Notification", isSwitch: true, action: .pushNotification))
        arr.append(SettingModel(name: "About Us", isSwitch: false, action: .aboutUs))
        arr.append(SettingModel(name: "Privacy Policy", isSwitch: false, action: .privacyPolicy))
        arr.append(SettingModel(name: "Rate App", isSwitch: false, action: .rateApp))
        arr.append(SettingModel(name: "Share App", isSwitch: false, action: .shareApp))
        arr.append(SettingModel(name: "More App", isSwitch: false, action: .moreApp))
        arr.append(SettingModel(name: "Delete Account", isSwitch: false, action: .deleteAccount))

        return arr
    }
}
