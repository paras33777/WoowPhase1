//
//  HomeDetailCollectionCell.swift
//  WooW
//
//  Created by Rahul Chopra on 08/05/21.
//

import Foundation
import UIKit

class HomeDetailCollectionCell: UICollectionViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var posterImgView: RoundImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var premiumLbl: UILabel!
    
    
    // MARK:- CORE METHODS
    func configure(movie: Movies) {
        posterImgView.showImage(imgURL: movie.movie_poster.leoSafe())
        movieNameLbl.text = movie.movie_title.leoSafe()
        durationLbl.text = movie.movie_duration.leoSafe()
        
        if movie.movie_access.leoSafe() == "Paid" {
            premiumLbl.roundCorner(rect: [.topRight, .bottomRight], roundCorner: 12.5)
            premiumLbl.isHidden = false
        } else {
            premiumLbl.isHidden = true
        }
    }
    
    
    func configure(show: ShowDetailIncoming.Show.Related_Shows) {
        posterImgView.showImage(imgURL: show.show_poster.leoSafe())
        movieNameLbl.text = show.show_title.leoSafe()
        durationLbl.isHidden = true
        premiumLbl.isHidden = true
    }
    
}
