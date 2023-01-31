//
//  MovieCatCell.swift
//  WooW
//
//  Created by Rahul Chopra on 03/05/21.
//

import Foundation
import UIKit

class MovieCatCell: UICollectionViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var catImgView: RoundImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var blurView: RoundView!
    
    
    // MARK:- FOR LIVE TV CATEGORIES
    func configure(category: CategoryIncoming.Category) {
        catImgView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127)
        nameLbl.text = category.category_name.leoSafe()
        
        if category.isSelected {
            catImgView.backgroundColor = UIColor.rgb(red: 235, green: 102, blue: 130)
        } else {
            catImgView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127)
        }
    }
    
    
    // MARK:- FOR LANGUAGES
    func configure(language: LanguageIncoming.Language) {
        catImgView.showImage(imgURL: language.language_image.leoSafe(), placeholderImage: "picture")
        nameLbl.text = language.language_name.leoSafe()
        
        if language.isSelected {
            blurView.backgroundColor = UIColor.rgb(red: 235, green: 102, blue: 130, alpha: 0.75)
        } else {
            blurView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127, alpha: 0.75)
        }
    }
    
    // MARK:- FOR GENRES
    func configure(genre: GenreIncoming.Genre) {
        catImgView.showImage(imgURL: genre.genre_image.leoSafe(), placeholderImage: "picture")
        nameLbl.text = genre.genre_name.leoSafe()
        
        if genre.isSelected {
            blurView.backgroundColor = UIColor.rgb(red: 235, green: 102, blue: 130, alpha: 0.75)
        } else {
            blurView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127, alpha: 0.75)
        }
    }
}
