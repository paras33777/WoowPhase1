//
//  Ext-MovieDetail.swift
//  WooW
//
//  Created by Rahul Chopra on 27/05/21.
//

import Foundation
import UIKit

extension MovieDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetail?.related_movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailCollectionCell", for: indexPath) as! HomeDetailCollectionCell
        cell.configure(movie: movieDetail!.related_movies![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (relatedCollectionView.frame.size.width / 3.0) - 20
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            vc.movie = movieDetail!.related_movies![indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


