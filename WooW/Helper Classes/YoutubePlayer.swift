//
//  YoutubePlayer.swift
//  WooW
//
//  Created by Rahul Chopra on 28/05/21.
//

import UIKit
import XCDYouTubeKit

class YoutubePlayer {
    
    static let shared = YoutubePlayer()
    
    
    // MARK:- CONFIGURE & SETUP PLAYER LAYER
    func configurePlayer(fileURL: String, playerView: UIView) {
        guard let url = URL(string: fileURL) else { return }
        
    }
    
}
