//
//  FilterTableCell.swift
//  WooW
//
//  Created by Rahul Chopra on 09/05/21.
//

import Foundation
import UIKit


class FilterTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tickImgView: UIImageView!
    
    func configure(index: Int) {
        if index == 0 {
            nameLbl.text = "NEWEST"
        } else if index == 1 {
            nameLbl.text = "OLDEST"
        } else if index == 2 {
            nameLbl.text = "A to Z"
        } else {
            nameLbl.text = "RANDOM"
        }
        
        self.backgroundColor = .white
        self.nameLbl.textColor = .black
    }
}
