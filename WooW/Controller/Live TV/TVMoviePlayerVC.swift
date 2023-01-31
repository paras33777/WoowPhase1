//
//  TVMoviePlayerVC.swift
//  WooW
//
//  Created by Rahul Chopra on 15/05/21.
//

import UIKit
import AVFoundation
//import JioAdsFramework

class TVMoviePlayerVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var totalDurLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var controlsView: UIView!
    
    // MARK:- PROPERTIES
    var tvModel: LiveTVIncoming.TV?
    var tvDetails: LiveTVDetailsIncoming.TVDetail?
//    var adView: JioAdView?
    var adspotId: String?
    var player = VGPlayer()

    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
        self.apiCalled(api: .livetv_details,
                       param: ["tv_id": tvModel?.tv_id ?? 0,
                               "user_id": Cookies.userInfo()?.user_id ?? 0])
        
        if Cookies.userInfo() == nil {
            self.subscriptionView.isHidden = false
        } else {
            self.subscriptionView.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playerTapAction))
        playerView.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.controlsAction(isHidden: true)
        }
//        self.configCacheAds()
//    self.adView?.loadAd()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.displayView.pause()
//        self.adView?.closeAd()
    }
    // MARK: - CORE METHODS
//    func configCacheAds() {
//        self.title = "InstreamVideo"
//        self.setValueInUserDefaults(objValue: "Production", for: "currentEnvironment")
//        
//        JioAdSdk.setPackageName(packageName: "com.woow")
//        self.adView = JioAdView.init(adSpotId: "lhx0g6oj", adType: .InstreamVideo, delegate: self, forPresentionClass: self, publisherContainer: self.playerView)
////        self.adView = JioAdView.init(adSpotId: "y5a83vx7", adType: .InstreamVideo, delegate: self, forPresentionClass: self, publisherContainer: self.playerView)
//        
//        self.adView?.setCustomInstreamAdContainer(container: self.playerView)// container view
//        self.playerView.isHidden = false
//
////        self.adView?.setRequestedAdDuration(adPodDuration: 5)
//        self.adView?.autoPlayMediaEnalble = true
//        self.adView?.setRefreshRate(refreshRate: 15)
//        self.adView?.hideAdControls()
//
//        self.adView?.cacheAd()
//    }
    // MARK:- CORE METHODS
    func showInfoOnUI() {
        let title = self.tvDetails != nil ? (self.tvDetails?.tv_title ?? "") : (self.tvModel?.tv_title ?? "")
        let category =  self.tvDetails != nil ? (self.tvDetails?.category_name ?? "") : ""
        let desc = self.tvDetails != nil ? (self.tvDetails?.description ?? "") : ""
        
        self.nameLbl.text = title
        self.titleLbl.text = title
        self.catLbl.text = category
        
        if Cookies.userInfo() != nil {
            self.setupPlayer()
        }
        
        
        let font = "<font face='Poppins-Medium' size='4.8' color= 'darkGray'>%@"
        let textData = String(format: font, desc).data(using: .utf8)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html]
        do {
            let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
            self.descTextView.attributedText = attText
        } catch {
            print(error)
        }
    }

    func openLoginVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInEmailVC") as! SignInEmailVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    
    func setupPlayer() {
        Player.shared.configurePlayer(fileURL: self.tvDetails?.tv_url ?? "",
                                      playerView: playerView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.currentTimeLbl.text = "00:00"
            self.slider.value = 0
//            self.totalDurLbl.text = Player.shared.fileDuration()
        }
        Player.shared.trackTimeObserver { (currentTime, timeInSec) in
            self.currentTimeLbl.text = "\(currentTime)"
            self.slider.value = timeInSec
//            self.totalDurLbl.text = Player.shared.fileDuration()
        }
        Player.shared.closureDidFinishPlaying = { isFinished in
            self.currentTimeLbl.text = "00:00"
            self.slider.value = 0
//            self.playPauseBtn.isSelected = !self.playPauseBtn.isSelected
//            self.playPauseBtn.setImage(isFinished == true ? #imageLiteral(resourceName: "play-btn") : #imageLiteral(resourceName: "pause-btn"), for: .normal)
        }
    }
    
    func controlsAction(isHidden: Bool) {
        self.controlsView.isHidden = isHidden
    }

    @objc func playerTapAction() {
        controlsAction(isHidden: !controlsView.isHidden)
        
        if !controlsView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                if !self.controlsView.isHidden {
                    self.controlsAction(isHidden: !self.controlsView.isHidden)
                }
            }
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        Player.shared.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionRev10(_ sender: UIButton) {
    }
    
    @IBAction func actionPrevVideo(_ sender: UIButton) {
    }
    
    @IBAction func actionPlayPause(_ sender: UIButton) {
        if Player.shared.isPaused() {
            sender.setImage(#imageLiteral(resourceName: "ic_pause"), for: .normal)
            Player.shared.play()
        } else {
            sender.setImage(#imageLiteral(resourceName: "ic_play"), for: .normal)
            Player.shared.pause()
        }
    }
    
    @IBAction func actionNextVideo(_ sender: UIButton) {
    }
    
    @IBAction func actionFor10(_ sender: UIButton) {
        Player.shared.forwardTime()
    }
    
    @IBAction func actionSubscription(_ sender: DesignableButton) {
        if Cookies.userInfo() != nil {
            
        } else {
//            self.openLoginVC()
            self.apiCalled(api: .subscription_plan, param: [:])
        }
    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
    }
    
    @IBAction func actionZoom(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZoomedPlayerVC") as? ZoomedPlayerVC {
            vc.player = Player.shared.player
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}



extension TVMoviePlayerVC {
    func apiCalled(api: Api, param: [String:Any]) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }
        

        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: api, jsonObject: params, method: .post) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            if api == .subscription_plan {
                if isSuccess(json: jsonDict) {
                    let subscription = SubscriptionPlanIncoming(dict: jsonDict)
                    let subscriptions = subscription.subscription ?? []
                    self.openSubscriptionList(subscriptions: subscriptions)
                } else {
                    Alert.showSimple("Server disconnected")
                }
            } else {
                let details = LiveTVDetailsIncoming(dict: jsonDict)
                if isSuccess(json: details.serverData) {
                    if let user_plan_status = details.user_plan_status,
                       let tv = details.detail {
                        if user_plan_status == 0 {
                            
                        } else {
                            
                        }
                        
                        self.tvDetails = tv
                        self.showInfoOnUI()
                    } else {
                        Alert.showSimple("\(details.serverData)")
                    }
                }
                    
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    
    func openSubscriptionList(subscriptions: [SubscriptionPlanIncoming.Subscription]) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListVC") as? SubscriptionListVC {
            vc.modalPresentationStyle = .overFullScreen
            subscriptions[0].isSelected = true
            vc.subscriptions = subscriptions
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - JIO ADS DELEGATE METHODS
//extension TVMoviePlayerVC: JIOAdViewProtocol {
//    func onAdReceived(adView: JioAdView) {
//        print("onAdReceived")
//    }
//
//    func onAdPrepared(adView: JioAdView) {
//        print("onAdPrepared")
//
////        if playCount == 2 {
////            self.adView?.loadAd()
////        }
//    }
//
//    func onAdRender(adView: JioAdView) {
//        print("onAdRender")
//    }
//
//    func onAdClicked(adView: JioAdView) {
//        print("onAdClicked")
//    }
//
//    func onAdRefresh(adView: JioAdView) {
//        print("onAdRefresh")
//    }
//
//    func onAdFailedToLoad(adView: JioAdView, error: JioAdError) {
//        print("onAdFailedToLoad : \(error)")
//    }
//
//    func onAdMediaEnd(adView: JioAdView) {
//        print("onAdMediaEnd")
//    }
//
//    func onAdClosed(adView: JioAdView, isVideoCompleted: Bool, isEligibleForReward: Bool) {
//        print("onAdClosed")
//        self.player.displayView.play()
//
////        self.adView?.setRequestedAdDuration(adPodDuration: 10)
//
//
//    }
//
//    func onAdMediaStart(adView: JioAdView) {
//        print("")
//        self.player.displayView.pause()
//    }
//
//    func onAdSkippable(adView: JioAdView) {
//        print("onAdSkippable")
//    }
//
//    func onAdMediaExpand(adView: JioAdView) {
//        print("onAdMediaExpand")
//    }
//
//    func onAdMediaCollapse(adView: JioAdView) {
//        print("onAdMediaCollapse")
//    }
//
//    func onMediaPlaybackChange(adView: JioAdView, mediaPlayBack: MediaPlayBack) {
//        print("onMediaPlaybackChange")
//    }
//
//    func onAdChange(adView: JioAdView, trackNo: Int) {
//        print("onAdChange")
//    }
//
//    func mediationLoadAd() {
//        print("")
//    }
//
//    func mediationRequesting() {
//        print("")
//    }
//}
