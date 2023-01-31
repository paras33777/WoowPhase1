//
//  SettingTableCell.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import Foundation
import UIKit

class SettingTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    func configure(model: SettingModel) {
        nameLbl.text = model.name
        settingSwitch.isOn = model.isSwitch
        settingSwitch.isHidden = !model.isSwitch
    }
}
