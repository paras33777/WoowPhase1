//
//  HomeTableCell.swift
//  WooW
//
//  Created by Rahul Chopra on 08/05/21.
//

import Foundation
import UIKit

class HomeTableCell: UITableViewCell {
    
    // MARK:- OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    var homeData: HomeModel.Response?
    weak var homeVC: HomeVC?
    
    
    // MARK:- LIFE CYCLE METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configure(homeData: HomeModel.Response) {
        self.homeData = homeData
        self.collectionView.reloadData()
    }
}


// MARK:- COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension HomeTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let homeData = homeData {
            if homeData.type.leoSafe().lowercased() == "movies" {
                return homeData.movies?.count ?? 0
            } else if homeData.type.leoSafe().lowercased() == "series"  {
                return homeData.shows?.count ?? 0
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows"  {
                return homeData.shows?.count ?? 0
            } else if homeData.type.leoSafe() == "RecentWatch" {
                return homeData.recentlyWatched?.count ?? 0
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
            } else if homeData.type.leoSafe().lowercased() == "series" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
                cell.posterImgView.contentMode = .scaleAspectFill
                cell.configure(show: homeData.shows![indexPath.row])
                return cell
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows" {
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
                let width = collectionView.frame.size.width / 3.0
                return CGSize(width: width, height: collectionView.frame.size.height)
            } else if homeData.type.leoSafe().lowercased() == "series" {
                let width = collectionView.frame.size.width / 3.0
                return CGSize(width: width, height: collectionView.frame.size.height)
            } else if homeData.type.leoSafe() == "RecentWatch" {
                let width = collectionView.frame.size.width / 1.3
                return CGSize(width: width, height: collectionView.frame.size.height)
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows"  {
                let width = collectionView.frame.size.width / 1.3
                return CGSize(width: width, height: collectionView.frame.size.height)
            }
        }
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let homeData = homeData {
            if homeData.type.leoSafe().lowercased() == "movies" {
                self.openMoviesScreen(movie: homeData.movies![indexPath.row])
            } else if homeData.type.leoSafe().lowercased() == "shows" ||
                        homeData.title.leoSafe() == "Popular Shows"  {
                self.openShowsScreen(show: homeData.shows![indexPath.row])
            } else if homeData.type.leoSafe().lowercased() == "series" {
                let show = Shows(dict: ["show_id": homeData.shows![indexPath.row].show_id ?? 0])
                self.openShowsScreen(show: show)
            } else if homeData.type.leoSafe() == "RecentWatch" {
                let type = homeData.recentlyWatched![indexPath.row].video_type.leoSafe()
                if type == "Movies" {
                    let movie = Movies(dict: ["movie_id": homeData.recentlyWatched![indexPath.row].video_id ?? 0])
                    self.openMoviesScreen(movie: movie)
                } else if type == "LiveTV" {
                    let tv = LiveTVIncoming.TV(dict: ["tv_id": homeData.recentlyWatched![indexPath.row].video_id ?? 0])
                    self.openLiveTV(tv: tv)
                } else if type == "Shows" {
                    let show = Shows(dict: ["show_id": homeData.recentlyWatched![indexPath.row].video_id ?? 0])
                    self.openShowsScreen(show: show)
                }
            }
        }
    }
    
    func openMoviesScreen(movie: Movies) {
        if let vc = homeVC?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            vc.movie = movie
            homeVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openShowsScreen(show: Shows) {
        if let vc = homeVC?.storyboard?.instantiateViewController(withIdentifier: "MoviePlayerVC") as? MoviePlayerVC {
            vc.show = show
            homeVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openLiveTV(tv: LiveTVIncoming.TV) {
        if let vc = homeVC?.storyboard?.instantiateViewController(withIdentifier: "TVMoviePlayerVC") as? TVMoviePlayerVC {
            vc.tvModel = tv
            homeVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
