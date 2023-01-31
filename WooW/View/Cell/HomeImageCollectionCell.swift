//
//  HomeImageCollectionCell.swift
//  WooW
//
//  Created by Rahul Chopra on 08/05/21.
//

import Foundation
import UIKit

class HomeImageCollectionCell: UICollectionViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var premLbl: UILabel!
    @IBOutlet weak var posterImgView: RoundImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    // MARK:- CORE METHODS
    func configure(show: Shows) {
        posterImgView.showImage(imgURL: show.show_poster.leoSafe(), isMode: true)
        nameLbl.text = show.show_title.leoSafe()
    }
    
    func configure(recent: RecentlyWatched) {
        posterImgView.showImage(imgURL: recent.video_thumb_image.leoSafe(), isMode: true)
        nameLbl.text = ""
    }
    
    
    func configure(tv: LiveTVIncoming.TV) {
        posterImgView.showImage(imgURL: tv.tv_logo.leoSafe(), placeholderImage: "picture")
        nameLbl.text = tv.tv_title.leoSafe()
        if tv.tv_access.leoSafe() == "Paid" {
            premLbl.roundCorner(rect: [.topLeft, .topRight, .bottomRight], roundCorner: 12.5)
            premLbl.isHidden = false
        } else {
            premLbl.isHidden = true
        }
    }
}
