//
//  SideBarCell.swift
//  WooW
//
//  Created by Rahul Chopra on 01/05/21.
//

import Foundation
import UIKit

class SideBarCell: UITableViewCell {
    
    @IBOutlet weak var menuImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configure(model: SideBarModel) {
        menuImgView.image = model.image
        nameLbl.text = model.name
    }
}
