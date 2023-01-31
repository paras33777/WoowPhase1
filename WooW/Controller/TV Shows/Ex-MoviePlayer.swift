//
//  Ex-MoviePlayer.swift
//  WooW
//
//  Created by Rahul Chopra on 10/07/21.
//

import Foundation
import UIKit

extension MoviePlayerVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showDetail?.related_shows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDetailCollectionCell", for: indexPath) as! HomeDetailCollectionCell
        cell.configure(show: showDetail!.related_shows![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (relatedShowTableView.frame.size.width / 1.5) - 20
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoviePlayerVC") as? MoviePlayerVC {
            vc.show = Shows(dict: ["show_id": (showDetail!.related_shows![indexPath.row].show_id ?? 0)])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


