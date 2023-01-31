//
//  SeeAllVC.swift
//  WooW
//
//  Created by Rahul Chopra on 09/05/21.
//

import Foundation
import UIKit

class SeeAllVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var nameLbl: UILabel!
    var homeData: HomeModel.Response!
    
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = homeData?.title.leoSafe()
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }
    
}


// MARK:- COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension SeeAllVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let homeData = homeData {
            if homeData.type.leoSafe().lowercased() == "movies" {
                return homeData.movies!.count
            } else if homeData.type.leoSafe().lowercased() == "series"  {
                return homeData.shows?.count ?? 0
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows"  {
                return homeData.shows!.count
            } else if homeData.type.leoSafe() == "RecentWatch" {
                return homeData.recentlyWatched!.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let homeData = homeData {
            if homeData.type.leoSafe().lowercased() == "movies" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailCollectionCell", for: indexPath) as! HomeDetailCollectionCell
                cell.configure(movie: homeData.movies![indexPath.row])
                return cell
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
                cell.configure(show: homeData.shows![indexPath.row])
                return cell
            } else if homeData.type.leoSafe().lowercased() == "series" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
                cell.configure(show: homeData.shows![indexPath.row])
                return cell
            } else if homeData.type.leoSafe() == "RecentWatch" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
                cell.configure(recent: homeData.recentlyWatched![indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let homeData = homeData {
            if homeData.type.leoSafe().lowercased() == "movies" {
                let width = (collectionView.frame.size.width / 3.0) - 20
                return CGSize(width: width, height: 170)
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows"  {
                let width = (collectionView.frame.size.width - 30) / 2.0
                return CGSize(width: width, height: 140)
            } else if homeData.type.leoSafe().lowercased() == "series" ||
                        homeData.type.leoSafe() == "RecentWatch" {
                let width = (collectionView.frame.size.width - 30) / 2.0
                return CGSize(width: width, height: 140)
            }
        }
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
}
