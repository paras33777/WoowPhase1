//
//  HomeVC.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import UIKit
import FSPagerView
import GoogleMobileAds

class HomeVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.automaticSlidingInterval = 3.5
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BannerPagerCell")
            //self.pagerView.itemSize = FSPagerView.automaticSize
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK:- PROPERTIES
    var bannerData = [Banner]()
    var homeData = [HomeModel.Response]()
    var purchasedProductId: String = ""
    var purchaseDate = ""
    var transId = ""
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        Location.shared.configure()
        self.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerView.frame = CGRect(origin: tableView.tableHeaderView!.bounds.origin,
                                 size: CGSize(width: UIScreen.main.bounds.width,
                                              height: tableView.tableHeaderView!.bounds.height))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.setupAdBannerView()
    }
    
    func setupAdBannerView() {
        let adView = UIView()
        adView.backgroundColor = .yellow
        self.view.addSubview(adView)
        adView.bringSubviewToFront(self.tableView)
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            adView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        adView.addSubview(bannerView)
        bannerView.adUnitID = appDetail!.banner_ad_id.leoSafe()
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        bannerView.backgroundColor = .red
        
    }
    
    // MARK:- API IMPLEMENTATIONS
    func getMovies() {
        let sign = API.shared.sign()
        let param = ["user_id": Cookies.userInfo()?.user_id ?? 0,
                     "salt": API.shared.salt,
                     "sign": sign
                    ] as [String : Any]

        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: .home, jsonObject: param) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
//            let home = HomeListIncoming(dict: jsonDict)
//            self.bannerData = home.vIDEO_STREAMING_APP?.slider ?? []
            
            let homeModel = HomeModel(dict: jsonDict)
            self.bannerData = homeModel.banners
            self.homeData = homeModel.data
            
            print(self.homeData)
            
            self.pageControl.numberOfPages = self.bannerData.count
            self.pageControl.currentPage = 0
            self.pagerView.reloadData()
            self.tableView.reloadData()
            self.checkUserIAPPurchaseStatus()
            
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
    
    func apiCalled(api: Api, param: [String:Any]) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }
        
        DispatchQueue.main.async {
            Hud.show(message: "", view: self.view)
        }
        WebServices.uploadData(url: api, jsonObject: params) { (jsonDict) in
            DispatchQueue.main.async {
                Hud.hide(view: self.view)
            }
            print(jsonDict)
            
            if api == .dashboard {
                if isSuccess(json: jsonDict) {
                    let dash = DashboardIncoming(dict: jsonDict)
                    if let dashb = dash.dashboard, let first = dashb.first {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                        let date = dateFormatter.date(from: self.purchaseDate)!
                        dateFormatter.dateFormat = "MMMM,  dd, yyyy"
                        let dateStr = dateFormatter.string(from: date)
                        
                        if first.last_invoice_date! != dateStr {
                            self.callPurchaseTransactionAPI()
                        }
                    }
                } else {
                    Alert.showSimple("Server disconnected")
                }
            }
        } failureHandler: { (errorDict) in
            DispatchQueue.main.async {
                Hud.hide(view: self.view)
            }
            print(errorDict)
        }
    }
    
    func callPurchaseTransactionAPI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
        let date = dateFormatter.date(from: purchaseDate)!
        dateFormatter.dateFormat = "MMMM,  dd, yyyy"
        let dateStr = dateFormatter.string(from: date)
        let tranDateStr = dateStr
        
        var params = [String:Any]()
        params["user_id"] = Cookies.userInfo()!.user_id ?? 0
        params["plan_id"] = purchasedProductId == IAPKeys.kMonthly ? 1 : (purchasedProductId == IAPKeys.kYearly ? 2 : 4)
        params["payment_id"] = transId
        params["payment_gateway"] = "RazorPay"
        params["postId"] = 0
        params["postType"] = PostType.movies.rawValue
        params["transaction_date"] = tranDateStr
        self.apiCalled(api: .transaction_add, param: params)
    }
    
    func checkUserIAPPurchaseStatus() {
        ReceiptValidator.sharedInstance.checkReceiptValidation { (isExpired, productIdentifier, transId, purchaseDate)  in
            if let isExpired = isExpired {
                if isExpired {
                    DispatchQueue.main.async {
                        self.view.makeToast("Your subscription has expired, please subscribe")
                    }
                } else {
                    print("Not Expired")
                    self.purchasedProductId = productIdentifier
                    self.transId = transId
                    self.purchaseDate = purchaseDate
                    self.apiCalled(api: .dashboard, param: ["user_id": Cookies.userInfo()?.user_id ?? 0])
                }
            }
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }
    
    @IBAction func actionSearch(_ sender: UIButton) {
    }
}



// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeCategoryView()
        headerView.backgroundColor = .clear
        headerView.label.text = homeData[section].title
        headerView.button.tag = section
        headerView.button.addTarget(self, action: #selector(seeAllAction(button:)), for: .touchUpInside)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell", for: indexPath) as! HomeTableCell
        cell.homeVC = self
        cell.configure(homeData: homeData[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    @objc func seeAllAction(button: UIButton) {
        let section = button.tag
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeeAllVC") as? SeeAllVC {
            vc.homeData = homeData[section]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK:- FSPAGER VIEW DATA SOURCE & DELEGATE METHODS
extension HomeVC : FSPagerViewDelegate, FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerData.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerCell", at: index)
        
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.showImage(imgURL: bannerData[index].slider_image.leoSafe(), isMode: true)
        cell.textLabel?.text = bannerData[index].slider_title.leoSafe()
        cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 15.0)
        cell.textLabel?.textColor = UIColor(white: 1, alpha: 0.8)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        if bannerData[index].slider_type.leoSafe() == "Series" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoviePlayerVC") as? MoviePlayerVC {
                vc.show = Shows(dict: ["show_id": (bannerData[index].slider_post_id ?? 0)])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if bannerData[index].slider_type.leoSafe() == "Movies" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                let movie = Movies(dict: ["movie_id": bannerData[index].slider_post_id ?? 0])
                vc.movie = movie
                navigationController?.pushViewController(vc, animated: true)
            }
        } else if bannerData[index].slider_type.leoSafe() == "LiveTV" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TVMoviePlayerVC") as? TVMoviePlayerVC {
                vc.tvModel = LiveTVIncoming.TV(dict: ["tv_id": bannerData[index].slider_post_id ?? 0])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if bannerData[index].slider_type.leoSafe() == "Shows" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoviePlayerVC") as? MoviePlayerVC {
                vc.show = Shows(dict: ["show_id": (bannerData[index].slider_post_id ?? 0)])
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
}


extension HomeVC: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        print("adViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("didFailToReceiveAdWithError:\n\(error)")
    }
}
