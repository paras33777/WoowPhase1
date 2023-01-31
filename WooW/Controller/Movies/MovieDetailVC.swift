//
//  MovieDetailVC.swift
//  WooW
//
//  Created by MAC on 16/05/21.
//

import UIKit
import WebKit
//import JioAdsFramework

class MovieDetailVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var durLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var imdbRatingLbl: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var descTxtViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var subsView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var totalDurLbl: UILabel!
    @IBOutlet weak var currentDurLbl: UILabel!
    @IBOutlet weak var relatedCollectionView: UICollectionView!
    @IBOutlet weak var videoPlayerLbl: UILabel!
    @IBOutlet weak var playerContentView: UIView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var zoomedView: UIView!
    
    // MARK:- PROPERTIES
    var movie: Movies?
    var movieDetail : MovieDetailIncoming.Movie?
    var userPlanStatus: Int = 0
//    var adView: JioAdView?
    var adspotId: String?
    var player = VGPlayer()

    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
        self.apiCalled(api: .movies_details,
                       param: ["movie_id": movie?.movie_id ?? 0,
                               "user_id": Cookies.userInfo()?.user_id ?? 0])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playerTapAction))
        playerContentView.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.controlsAction(isHidden: true)
        }
//        self.configCacheAds()
//    self.adView?.loadAd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Player.shared.pause()
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
    
    func showInfoOnUI() {
        if let detail = self.movieDetail {
            headingLbl.text = detail.movie_title.leoSafe()
            nameLbl.text = detail.movie_title.leoSafe()
            dateLbl.text = detail.release_date.leoSafe()
            langLbl.text = detail.language_name.leoSafe()
            genreLbl.text = detail.genre_list?.map({$0.genre_name.leoSafe()}).joined(separator: " | ") ?? ""
            imdbRatingLbl.text = detail.imdb_rating.leoSafe()
            durLbl.text = detail.movie_duration
            
            if userPlanStatus == 1 {
                if detail.video_type == .URL {
                    let urlString = detail.video_url.leoSafe()
                    self.setupPlayer(url: urlString)
                } else if detail.video_type == .EMBED {
                    let urlString = detail.video_url.leoSafe().embedYoutubeLink()
                    self.controlsView.isHidden = true
                    self.setupWebView(urlString: urlString)
                }
            }

            let font = "<font face='Poppins-Medium' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, detail.description.leoSafe()).data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)

                let txtViewWidth = UIScreen.main.bounds.width - 10
                self.descTxtViewHeightConst.constant = attText.boundingRect(with: CGSize(width: txtViewWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], context: nil).height //detail.description.leoSafe().height(withConstrainedWidth: txtViewWidth, font: UIFont(name: "Poppins-Medium", size: 14)!)

                self.descTextView.attributedText = attText
            } catch {
                print(error)
            }
        }
    }
    
    func setupWebView(urlString: String) {
        let webView = WKWebView(frame: self.playerView.bounds)
        webView.backgroundColor = .black
        playerView.addSubview(webView)
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func setupPlayer(url: String) {
        Player.shared.configurePlayer(fileURL: url,
                                      playerView: playerView)
        self.totalDurLbl.textColor = .white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.currentDurLbl.text = "00:00"
            self.slider.value = 0
            self.slider.minimumValue = 0
            self.totalDurLbl.text = Player.shared.fileDuration()
            self.slider.maximumValue = NumberFormatter().number(from: Player.shared.fileDuration())?.floatValue ?? 0
        }
        Player.shared.trackTimeObserver { (currentTime, timeInSec) in
            self.currentDurLbl.text = "\(currentTime)"
            self.slider.value = timeInSec
            self.totalDurLbl.text = Player.shared.fileDuration()
            self.slider.maximumValue = Float(Player.shared.fileTimeIntervals())
        }
        Player.shared.closureDidFinishPlaying = { isFinished in
            self.currentDurLbl.text = "00:00"
            self.slider.value = 0
        }
    }
    
    func controlsAction(isHidden: Bool) {
        self.controlsView.isHidden = isHidden
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
    @IBAction func actionBack(_ sender: UIButton) {
        Player.shared.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubscription(_ sender: DesignableButton) {
        if Cookies.userInfo() != nil {
            self.apiCalled(api: .subscription_plan, param: [:])
        } else {
//            self.openSignInScreen()
            self.apiCalled(api: .subscription_plan, param: [:])
        }
    }
    
    @IBAction func actionRev10(_ sender: UIButton) {
        Player.shared.reverseTime()
    }
    
    @IBAction func actionPrev(_ sender: UIButton) {
        Player.shared.restartVideo()
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
    
    @IBAction func actionZoom(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZoomedPlayerVC") as? ZoomedPlayerVC {
            vc.player = Player.shared.player
            vc.movieDetail = movieDetail
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
//        self.playerContentView.translatesAutoresizingMaskIntoConstraints = false
//        self.zoomedView.isHidden = false
//        self.zoomedView.addSubview(playerContentView)
//        playerContentView.frame = CGRect(origin: CGPoint(x: self.zoomedView.bounds.size.width, y: 0),
//                                         size: CGSize(width: self.zoomedView.bounds.size.height,
//                                                      height: self.zoomedView.bounds.size.width))
//        self.playerContentView.transform = CGAffineTransform(rotationAngle: .pi / 2)
//        Player.shared.resizePlayer(frame: CGRect(origin: CGPoint(x: 30,
//                                                                 y: -100),
//                                                 size: CGSize(width: self.zoomedView.bounds.size.height,
//                                                              height: self.zoomedView.bounds.size.width)))
//
//        self.controlsView.frame =
//        print(self.playerContentView.frame)
//        print(self.playerView.frame)
//        print(self.controlsView.frame)

    }
    
    @IBAction func actionSlider(_ sender: UISlider) {
        Player.shared.forwardTime(to: sender.value)
    }
}


extension MovieDetailVC {
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
            } else if api == .movies_details {
                let details = MovieDetailIncoming(dict: jsonDict)
                if isSuccess(json: details.serverData) {
                    if let movieDetail = details.movie {
                        self.userPlanStatus = details.user_plan_status.leoSafe()
                        self.subsView.isHidden = details.user_plan_status.leoSafe() == 0 ? false : true
                        self.movieDetail = movieDetail
                        self.showInfoOnUI()
                        self.relatedCollectionView.reloadData()
                    }
                } else {
                    Alert.showSimple("\(details.serverData)")
                }
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    
    func openSubscriptionList(subscriptions: [SubscriptionPlanIncoming.Subscription]) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListVC") as? SubscriptionListVC {
            vc.subscriptions = subscriptions
            vc.postId = movieDetail?.movie_id ?? 0
            vc.postType = .movies
            vc.cameVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - JIO ADS DELEGATE METHODS
//extension MovieDetailVC: JIOAdViewProtocol {
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
