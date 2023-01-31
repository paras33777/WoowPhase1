//
//  ContainerVC.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import UIKit

class ContainerVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideBarView: UIView!
    
    // MARK:- PROPERTIES
    var sideMenuWidth = CGFloat()
    var isSideMenuOpen = false
    
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.updateUI()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NotificationKeys.kToggleMenu, object: nil)
    }

    func updateUI() {
        fadeView.backgroundColor = UIColor.clear
        fadeView.alpha = 0
        
        self.view.layoutIfNeeded()
        sideMenuWidth = sideBarView.frame.size.width
        sideMenuLeadingConstraint.constant = -sideMenuWidth
    }
    
    @objc func toggleSideMenu() {
        if isSideMenuOpen {
            // close the side menu
            sideMenuLeadingConstraint.constant = -sideMenuWidth
            sideBarView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.fadeView.alpha = 0
            }
            isSideMenuOpen = false
        }
        else {
            // open the side menu
            sideMenuLeadingConstraint.constant = 0
            sideBarView.isHidden = false
            fadeView.backgroundColor = UIColor.darkGray
            UIView.animate(withDuration: 0.6) {
                self.view.layoutIfNeeded()
               self.fadeView.alpha = 0.7
            }
            isSideMenuOpen = true
        }
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func fadeViewTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NotificationKeys.kToggleMenu, object: nil)
    }
    
}
