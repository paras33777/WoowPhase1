//
//  SubscriptionTableCell.swift
//  WooW
//
//  Created by Rahul Chopra on 09/05/21.
//

import Foundation
import UIKit

class SubscriptionTableCell: UITableViewCell {
    
    @IBOutlet weak var cornerView: RoundView!
    @IBOutlet weak var radioImgView: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var planLbl: UILabel!
    
    
    func configure(index: Int, subscription: SubscriptionPlanIncoming.Subscription) {
//        cornerView.backgroundColor = index == 0 ? .white : UIColor.rgb(red: 76, green: 76, blue: 76)
//        cornerView.borderColor = index == 0 ? UIColor.rgb(red: 233, green: 63, blue: 51) : .clear
//        radioImgView.image = index == 0 ? #imageLiteral(resourceName: "radio-fill") : #imageLiteral(resourceName: "radio-unfill")
//        priceLbl.textColor = index == 0 ? UIColor.rgb(red: 64, green: 64, blue: 64) : .white
//        currencyLbl.textColor = index == 0 ? UIColor.rgb(red: 76, green: 76, blue: 76) : .white
//        durationLbl.textColor = index == 0 ? UIColor.rgb(red: 233, green: 63, blue: 51) : UIColor.rgb(red: 171, green: 171, blue: 171)
//        planLbl.textColor = index == 0 ? UIColor.rgb(red: 76, green: 76, blue: 76) : UIColor.rgb(red: 202, green: 202, blue: 202)
        
        cornerView.backgroundColor = subscription.isSelected ? .white : UIColor.rgb(red: 76, green: 76, blue: 76)
        cornerView.borderColor = subscription.isSelected ? UIColor.rgb(red: 233, green: 63, blue: 51) : .clear
        radioImgView.image = subscription.isSelected ? #imageLiteral(resourceName: "radio-fill") : #imageLiteral(resourceName: "radio-unfill")
        priceLbl.textColor = subscription.isSelected ? UIColor.rgb(red: 64, green: 64, blue: 64) : .white
        currencyLbl.textColor = subscription.isSelected ? UIColor.rgb(red: 76, green: 76, blue: 76) : .white
        durationLbl.textColor = subscription.isSelected ? UIColor.rgb(red: 233, green: 63, blue: 51) : UIColor.rgb(red: 171, green: 171, blue: 171)
        planLbl.textColor = subscription.isSelected ? UIColor.rgb(red: 76, green: 76, blue: 76) : UIColor.rgb(red: 202, green: 202, blue: 202)
        
//        priceLbl.text = subscription.plan_price.leoSafe()
        priceLbl.text = subscription.product != nil ? subscription.product!.localizedPrice : "0"
        currencyLbl.text = subscription.product != nil ? subscription.product!.priceLocale.currencyCode.leoSafe() : "$"
//        currencyLbl.text = subscription.currency_code.leoSafe()
        durationLbl.text = subscription.plan_duration.leoSafe()
        planLbl.text = subscription.plan_name.leoSafe()
        
    }
    
}
