//
//  MoviePlayerVC.swift
//  WooW
//
//  Created by Rahul Chopra on 13/05/21.
//

import UIKit
import MobileVLCKit
//import JioAdsFramework

class MoviePlayerVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var durLbl: UILabel!
    @IBOutlet weak var langLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var imdbRatingLbl: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var descTxtViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var seasonLbl: UILabel!
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerContentView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var totalDurLbl: UILabel!
    @IBOutlet weak var currentDurLbl: UILabel!
    @IBOutlet weak var subsView: UIView!
    @IBOutlet weak var relatedShowTableView: UICollectionView!
     
    // MARK:- PROPERTIES
    var show: Shows?
    var showDetail: ShowDetailIncoming.Show?
    var episodes = [ShowSeasonModel.Episode]()
    var userPlanStatus: Int = 0

    var player = VGPlayer()
    var isPaused = false
    var isTrailor: Bool = false
//    var adView: JioAdView?
    var adspotId: String?
    let mediaPlayer = VLCMediaPlayer()

    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
        self.apiCalled(api: .show_details, param: ["show_id": show?.show_id ?? 0])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(playerTapAction))
        playerContentView.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.controlsAction(isHidden: true)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        
//            self.configCacheAds()
//        self.adView?.loadAd()
        

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Player.shared.pause()
        self.player.displayView.pause()
//        self.adView?.closeAd()


    }
//    func configurePlayer() {
////        player.displayView.portraitPlayerVC = self
//        playerView.addSubview(self.player.displayView)
//        player.displayView.isDisplayControl = false
//        self.player.backgroundMode = .suspend
//
//        self.player.delegate = self
//        self.player.displayView.delegate = self
//        self.player.displayView.snp.makeConstraints { [weak self] (make) in
//            guard let strongSelf = self else { return }
//            make.top.equalTo(strongSelf.playerView.snp.top)
//            make.left.equalTo(strongSelf.playerView.snp.left)
//            make.right.equalTo(strongSelf.playerView.snp.right)
//            make.bottom.equalTo(strongSelf.playerView.snp.bottom)
//        }
//        self.player.displayView.isCloseBtnHidden = true
//    }
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
        if let detail = self.showDetail {
            nameLbl.text = detail.show_name.leoSafe()
//            dateLbl.text = detail.
            headingLbl.text = detail.show_name.leoSafe()
            langLbl.text = detail.show_lang.leoSafe()
            genreLbl.text = detail.genre_list?.map({$0.genre_name.leoSafe()}).joined(separator: " | ") ?? ""
            if let seasons = detail.season_list, let first = seasons.first {
                seasonLbl.text = first.season_name.leoSafe()
            }
            
            imdbRatingLbl.text = detail.imdb_rating.leoSafe()
            
            self.subsView.isHidden = userPlanStatus == 0 ? false : true
            if userPlanStatus == 1 {
                if episodes.count > 0 {
                    let selectedEpisode = episodes.filter({$0.isSelected})[0]
                    if selectedEpisode.video_type == .URL {
                        let urlString = selectedEpisode.video_url.leoSafe()
                        self.setupPlayer(url: urlString)
                    }
                }
            }
            
//            let font = "<font face='Poppins-Medium' size='4.8' color= 'darkGray'>%@"
//            let textData = String(format: font, detail.show_info.leoSafe()).data(using: .utf8)
//            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
//                            NSAttributedString.DocumentType.html]
//            do {
//                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
//                
//                let txtViewWidth = UIScreen.main.bounds.width - 10
//                self.descTxtViewHeightConst.constant = detail.show_info.leoSafe().height(withConstrainedWidth: txtViewWidth, font: UIFont(name: "Poppins-Medium", size: 16.0)!)
//                
//                self.descTextView.attributedText = attText
//            } catch {
//                print(error)
//            }
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubscription(_ sender: DesignableButton) {
        if Cookies.userInfo() != nil {
            self.apiCalled(api: .subscription_plan, param: [:])
        } else {
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
            let selectedEpisode = episodes.filter({$0.isSelected})[0]
            vc.tvEpisode = selectedEpisode
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


extension MoviePlayerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableCell", for: indexPath) as! EpisodeTableCell
        cell.nameLbl.text = episodes[indexPath.row].episode_title.leoSafe()
        cell.nameLbl.textColor = episodes[indexPath.row].isSelected ? UIColor.rgb(red: 233, green: 63, blue: 67) : .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.episodes.forEach({$0.isSelected = false})
        self.episodes[indexPath.row].isSelected = true
        self.durLbl.text = self.episodes[indexPath.row].duration
        Player.shared.pause()
        self.tableView.reloadData()
//        self.adView?.removeFromSuperview()
//                self.adView?.closeAd()

//                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        self.showInfoOnUI()
//                            self.configCacheAds()
//                            self.adView?.loadAd()
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        
//        self.configCacheAds()
//        self.adView?.loadAd()
//    }
//        self.adView?.loadAd()
        
//        self.showInfoOnUI()
        
    }
}


extension MoviePlayerVC {
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
            
            print("-------------")
            print("-------------")
            print(jsonDict)
            
            
            if api == .show_details {
                let details = ShowDetailIncoming(dict: jsonDict)
                if isSuccess(json: details.serverData) {
                    if let showList = details.show {
                        self.showDetail = showList
                        self.showInfoOnUI()
                        self.apiCalled(api: .episodes,
                                       param: ["season_id": showList.season_list?.first?.season_id ?? 0,
                                               "user_id": Cookies.userInfo()?.user_id ?? 0])
                    }
                } else {
                }
            } else if api == .episodes {
                let season = ShowSeasonModel(dict: jsonDict)
                if isSuccess(json: season.serverData) {
                    self.userPlanStatus = season.user_plan_status ?? 0
                    self.episodes = season.episodes
                    if self.episodes.count > 0 {
                        self.episodes[0].isSelected = true
                        self.durLbl.text = self.episodes[0].duration
                    }
                    self.showInfoOnUI()
                    self.dateLbl.text = self.episodes.first?.release_date ?? ""
                    DispatchQueue.main.async {
                        self.tblViewHeightConst.constant = CGFloat((self.episodes.count * 45) + 45)
                        self.view.layoutIfNeeded()
                        self.tableView.reloadData()
                        self.relatedShowTableView.reloadData()
                    }
                    
                } else {
                    self.view.makeToast("Server disconnected")
                }
            } else if api == .subscription_plan {
                if isSuccess(json: jsonDict) {
                    let subscription = SubscriptionPlanIncoming(dict: jsonDict)
                    let subscriptions = subscription.subscription ?? []
                    self.openSubscriptionList(subscriptions: subscriptions)
                } else {
                    Alert.showSimple("Server disconnected")
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
            vc.postId = showDetail?.show_id ?? 0
            vc.postType = .shows
            vc.cameVC = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: - JIO ADS DELEGATE METHODS
//extension MoviePlayerVC: JIOAdViewProtocol {
//    func onAdReceived(adView: JioAdView) {
//        print("onAdReceived")
//
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
////        self.showInfoOnUI()
//
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
