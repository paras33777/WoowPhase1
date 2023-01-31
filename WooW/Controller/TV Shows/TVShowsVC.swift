//
//  TVShowsVC.swift
//  WooW
//
//  Created by Rahul Chopra on 10/05/21.
//

import UIKit

class TVShowsVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet var langGenreBtns: [UIButton]!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tvShowCollectionView: UICollectionView!
    @IBOutlet weak var noItemView: UIView!
    
    // MARK:- PROPERTIES
    var languages = [LanguageIncoming.Language]()
    var genres = [GenreIncoming.Genre]()
    var shows = [Shows]()
    var isGenreSelected: Bool = false
    var filterAction: FilterEnum = .newest
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCalled(api: .languages, param: [:])
    }
    
    func callListAPI(lang_id: Int, filter: FilterEnum = .newest) {
        self.apiCalled(api: .shows_by_language,
                       param: ["lang_id": lang_id, "filter": filter.rawValue])
    }
    
    func callGenreListAPI(genre_id: Int, filter: FilterEnum = .newest) {
        self.apiCalled(api: .shows_by_genre,
                       param: ["genre_id": genre_id, "filter": filter.rawValue])
    }
    
    // MARK:- IBACTIONS
    @IBAction func actionSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }
    
    @IBAction func actionLangGenre(_ sender: UIButton) {
        activeLbl.translatesAutoresizingMaskIntoConstraints = true
        activeLbl.frame = CGRect(x: sender.frame.origin.x,
                                 y: sender.frame.size.height - 2.0,
                                 width: sender.frame.size.width,
                                 height: 2.0)
        self.view.layoutIfNeeded()
        
        isGenreSelected = sender.tag == 0 ? false : true
        if isGenreSelected {
            self.apiCalled(api: .genres, param: [:])
        } else {
            self.apiCalled(api: .languages, param: [:])
        }
        self.collectionView.reloadData()
    }
    
    @IBAction func actionFilter(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as? FilterVC {
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.closureDidTap = { action in
                self.filterAction = action
                if self.isGenreSelected  {
                    self.callGenreListAPI(genre_id:self.genres.filter({$0.isSelected})[0].genre_id.leoSafe(), filter: action)
                } else {
                    self.callListAPI(lang_id:self.languages.filter({$0.isSelected})[0].language_id.leoSafe(), filter: action)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}


// MARK:- COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension TVShowsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tvShowCollectionView {
            return shows.count
        } else {
            return isGenreSelected ? genres.count : languages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tvShowCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeImageCollectionCell", for: indexPath) as! HomeImageCollectionCell
            cell.configure(show: shows[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCatCell", for: indexPath) as! MovieCatCell
            if isGenreSelected {
                cell.configure(genre: genres[indexPath.row])
            } else {
                cell.configure(language: languages[indexPath.row])
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tvShowCollectionView {
            let width = (collectionView.frame.size.width - 30) / 2.0
            return CGSize(width: width, height: width)
        } else {
            let width = (self.view.frame.size.width - 40) / 3
            return CGSize(width: width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.tvShowCollectionView {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoviePlayerVC") as? MoviePlayerVC {
                vc.show = shows[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if isGenreSelected {
                self.inactiveGenreCell()
                self.genres[indexPath.row].isSelected = true
                self.callGenreListAPI(genre_id: genres[indexPath.row].genre_id.leoSafe(),
                                      filter: filterAction)
            } else {
                self.inactiveLanguageCell()
                self.languages[indexPath.row].isSelected = true
                self.callListAPI(lang_id: languages[indexPath.row].language_id.leoSafe(),
                                 filter: filterAction)
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? MovieCatCell {
                cell.blurView.backgroundColor = UIColor.rgb(red: 235, green: 102, blue: 130, alpha: 0.75)
            }
        }
    }
    
    func inactiveLanguageCell() {
        for index in 0..<self.languages.count {
            self.languages[index].isSelected = false
            if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MovieCatCell {
                cell.blurView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127, alpha: 0.75)
            }
        }
    }
    
    func inactiveGenreCell() {
        for index in 0..<self.genres.count {
            self.genres[index].isSelected = false
            if let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MovieCatCell {
                cell.blurView.backgroundColor = UIColor.rgb(red: 127, green: 127, blue: 127, alpha: 0.75)
            }
        }
    }
}
