//
//  SportsVC.swift
//  WooW
//
//  Created by Rahul Chopra on 12/05/21.
//

import UIKit

class SportsVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var noItemView: UIView!
    
    var filterAction: FilterEnum = .newest
    var categories = [CategoryIncoming.Category]()
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategoriesAPI()
        self.noItemView.isHidden = false
    }
    
    
    // MARK:- CORE METHODS
    func getCategoriesAPI() {
        self.apiCalled(api: .sports_category, param: [:])
    }
    
    func getSportsListAPI(filter: FilterEnum = .newest) {
        let selectedCat = categories.filter({$0.isSelected}).first!
        self.apiCalled(api: .sports_by_category,
                       param: ["category_id": selectedCat.category_id.leoSafe(),
                               "filter": filter.rawValue])
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
                self.filterAction = action
                
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}


extension SportsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sportsCollectionView {
            return 7
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sportsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCatCell", for: indexPath) as! MovieCatCell
            cell.configure(category: categories[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sportsCollectionView {
            let width = (collectionView.frame.size.width - 30) / 2.0
            return CGSize(width: width, height: width)
        } else {
            let width = (self.view.frame.size.width - 40) / 3
            return CGSize(width: width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sportsCollectionView {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TVMoviePlayerVC") as? TVMoviePlayerVC {
//                vc.tvModel = self.tvList[indexPath.row]
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        } else {
            self.inactiveCategoryCell()
            self.categories[indexPath.row].isSelected = true
            if let cell = collectionView.cellForItem(at: indexPath) as? MovieCatCell {
                cell.catImgView.backgroundColor = UIColor.rgb(red: 235, green: 102, blue: 130)
            }
            self.getSportsListAPI(filter: self.filterAction)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView != sportsCollectionView {
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
extension SportsVC {
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
            
            if api == .sports_category {
                let details = CategoryIncoming(dict: jsonDict)
                if isSuccess(json: details.serverData) {
                    self.categories = details.categories ?? []
                    if self.categories.count > 0 {
                        self.categories[0].isSelected = true
                    }
                    
                    self.collectionView.reloadData()
                    self.getSportsListAPI(filter: self.filterAction)
                    
//                    if self.categories.count > 0 {
//                        self.noItemView.isHidden = true
//                    } else {
//                        self.noItemView.isHidden = false
//                    }
                } else {
                    Alert.showSimple("\(details.serverData)")
                }
            } else if api == .sports_by_category {
                
                let leo = LeoSwiftCoder()
                leo.leoClassMake(withName: "SportsListIncoming", json: jsonDict)
                
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
            print(errorDict)
        }
    }
}

