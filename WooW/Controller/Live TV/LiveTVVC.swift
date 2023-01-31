//
//  LiveTVVC.swift
//  WooW
//
//  Created by Rahul Chopra on 12/05/21.
//

import UIKit

class LiveTVVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tvCollectionView: UICollectionView!
    @IBOutlet weak var noItemView: UIView!
    var categories = [CategoryIncoming.Category]()
    var tvList = [LiveTVIncoming.TV]()
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.callCategoryApi()
    }
    
    
    // MARK:- CORE METHODS
    func showHideNoItemView() {
        if tvList.count > 0 {
            self.noItemView.isHidden = true
            self.tvCollectionView.isHidden = false
        } else {
            self.noItemView.isHidden = false
            self.tvCollectionView.isHidden = true
        }
    }
    
    func callCategoryApi() {
        let sign = API.shared.sign()
        let param = ["salt": API.shared.salt,
                     "sign": sign] as [String : Any]
        self.apiCalled(api: .livetv_category, params: param)
    }
    
    func callListApi(filterAction: FilterEnum = .newest) {
        let sign = API.shared.sign()
        let selectedCat = categories.filter({$0.isSelected}).first!
        let param = ["salt": API.shared.salt,
                     "sign": sign,
                     "category_id": selectedCat.category_id.leoSafe(),
                     "filter": filterAction.rawValue] as [String : Any]
        self.apiCalled(api: .livetv_by_category, params: param)
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }
    
    @IBAction func actionFilter(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.closureDidTap = { action in
                self.callListApi(filterAction: action)
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension LiveTVVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tvCollectionView {
            return tvList.count
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tvCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
            cell.configure(tv: tvList[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCatCell", for: indexPath) as! MovieCatCell
            cell.configure(category: categories[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tvCollectionView {
            let width = (collectionView.frame.size.width - 30) / 2.0
            return CGSize(width: width, height: width)
        } else {
            let width = (self.view.frame.size.width - 40) / 3
            return CGSize(width: width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tvCollectionView {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TVMoviePlayerVC") as? TVMoviePlayerVC {
                vc.tvModel = self.tvList[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.inactiveCategoryCell()
            self.categories[indexPath.row].isSelected = true
            if let cell = collectionView.cellForItem(at: indexPath) as? MovieCatCell {
                cell.catImgView.backgroundColor = UIColor.rgb(red: 235, green: 102, blue: 130)
            }
            self.callListApi()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView != tvCollectionView {
            self.categories[indexPath.row].isSelected = false
            if let cell = collectionView.cellForItem(at: indexPath) as? MovieCatCell {
                cell.catImgView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127)
            }
         }
    }
    
    func inactiveCategoryCell() {
        for index in 0..<self.categories.count {
            self.categories[index].isSelected = false
            if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MovieCatCell {
                cell.catImgView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127)
            }
        }
    }
}


// MARK:- API IMPLEMENTATIONS
extension LiveTVVC {
    func apiCalled(api: Api, params: [String:Any]) {
        Hud.show(message: "", view: self.view)
        WebServices.uploadData(url: api, jsonObject: params) { (jsonDict) in
            Hud.hide(view: self.view)
            print(jsonDict)
            
            if api == .livetv_category {
                if let cat = CategoryIncoming(dict: jsonDict).categories {
                    self.categories = cat
                    if self.categories.count > 0 {
                        self.categories[0].isSelected = true
                    }
                    
                    self.callListApi()
                }
                self.collectionView.reloadData()
            } else if api == .livetv_by_category {
                
                if let list = LiveTVIncoming(dict: jsonDict).tv {
                    self.tvList = list
                }
                
                self.tvCollectionView.reloadData()
                self.showHideNoItemView()
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
}
