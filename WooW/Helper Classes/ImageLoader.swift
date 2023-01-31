//
//  ImageLoader.swift
//  WooW
//
//  Created by Rahul Chopra on 07/05/21.
//

import Foundation
import UIKit
import SDWebImage
import Nuke

extension UIImageView {
    func showImage(image: String) {
        self.image = UIImage(named: image)
    }
    
//    func showImage(imgURL: String, placeholderImage: String? = nil) {
//       if let imageURL = URL(string: imgURL) {
//
//          var placeImage: UIImage? = nil
//          if placeholderImage != nil {
//             placeImage = UIImage(named: placeholderImage!)
//             self.image = placeImage
//             self.contentMode = .scaleAspectFit
//          }
//
//        self.sd_setImage(with: imageURL, placeholderImage: placeImage, options: [.continueInBackground]) { (image, error, cacheType, url) in
//             if error != nil {
//                self.image = placeImage
//                self.contentMode = .scaleAspectFit
//                self.image = UIImage(named: placeholderImage ?? "")
//             } else {
//                self.contentMode = .scaleAspectFill
//
//                if image == nil {
//                    self.contentMode = .scaleAspectFit
//                    self.image = UIImage(named: placeholderImage ?? "")
//                } else {
//                    self.sd_setImage(with: imageURL, placeholderImage: placeImage)
//                }
//             }
//          }
//
//       }
//    }
    
    func showImage(imgURL: String, placeholderImage: String? = nil, isMode: Bool = false) {
        if let imageURL = URL(string: imgURL.replacingOccurrences(of: " ", with: "%20")) {
          
          var placeImage: UIImage? = nil
          if placeholderImage != nil {
             placeImage = UIImage(named: placeholderImage!)
             self.image = placeImage
            if !isMode {
                self.contentMode = .scaleAspectFit
            }
          }
          
        Nuke.loadImage(with: imageURL, options: .shared, into: self) { (response, compBytes, total) in
            if total > compBytes {
                self.image = UIImage(named: placeholderImage ?? "")
            }
        } completion: { (response) in
            let imageResp = try? response.get()
            if imageResp != nil {
                if !isMode {
                    self.contentMode = .scaleAspectFill
                }
                self.image = imageResp?.image
            } else {
                if !isMode {
                    self.contentMode = .scaleAspectFit
                }
                self.image = UIImage(named: placeholderImage ?? "")
            }
        }
       }
    }
    
}
