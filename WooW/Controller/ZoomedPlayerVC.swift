//
//  ZoomedPlayerVC.swift
//  WooW
//
//  Created by Rahul Chopra on 22/05/21.
//

import UIKit
import AVKit

class ZoomedPlayerVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var sliderView: UIView!
    var movieDetail : MovieDetailIncoming.Movie?
    var tvEpisode: ShowSeasonModel.Episode?
    var player: AVPlayer?
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(playerTapAction))
        playerView.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.controlsAction(isHidden: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        self.setupPlayer()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    
    // MARK:- CORE METHODS
    func setupPlayer() {
        Player.shared.pause()
        Player.shared.changePlayerView(playerView: playerView, avPlayer: Player.shared.player!)
//        Player.shared.playerLayer?.videoGravity = .resizeAspect

        self.totalTimeLbl.textColor = .white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.currentTimeLbl.text = "00:00"
            self.slider.value = 0
            self.slider.minimumValue = 0
            self.totalTimeLbl.text = Player.shared.fileDuration()
            self.slider.maximumValue = NumberFormatter().number(from: Player.shared.fileDuration())?.floatValue ?? 0
        }
        Player.shared.trackTimeObserver { (currentTime, timeInSec) in
            self.currentTimeLbl.text = "\(currentTime)"
            self.slider.value = timeInSec
            self.totalTimeLbl.text = Player.shared.fileDuration()
            self.slider.maximumValue = Float(Player.shared.fileTimeIntervals())
            print("Playting")
        }
        Player.shared.closureDidFinishPlaying = { isFinished in
            self.currentTimeLbl.text = "00:00"
            self.slider.value = 0
        }
    }

    func controlsAction(isHidden: Bool) {
        self.controlsView.isHidden = isHidden
        self.sliderView.isHidden = isHidden
    }

    @objc func playerTapAction() {
        controlsAction(isHidden: !controlsView.isHidden)
        
        if !controlsView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if !self.controlsView.isHidden {
                    self.controlsAction(isHidden: !self.controlsView.isHidden)
                }
            }
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSlider(_ sender: UISlider) {
        Player.shared.forwardTime(to: sender.value)
    }
    
    @IBAction func actionUnzoom(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionRev10(_ sender: UIButton) {
        Player.shared.reverseTime()
    }
    
    @IBAction func actionRev(_ sender: UIButton) {
        Player.shared.restartVideo()
    }
    
    @IBAction func actionPause(_ sender: UIButton) {
        if Player.shared.isPaused() {
            sender.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
            Player.shared.play()
        } else {
            sender.setImage(#imageLiteral(resourceName: "ic_play"), for: .normal)
            Player.shared.pause()
        }
    }
    
    @IBAction func actionFor(_ sender: UIButton) {
    }
    
    @IBAction func actionFor10(_ sender: UIButton) {
        Player.shared.forwardTime()
    }
    
}
