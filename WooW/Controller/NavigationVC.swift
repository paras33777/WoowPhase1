//
//  NavigationVC.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import UIKit

class NavigationVC: UINavigationController {

    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeVC()
    }
    
    
    // MARK:- CORE FUNCTIONS
    func initializeVC() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadViewControllers), name: NotificationKeys.kLoadViewController, object: nil)
        
        if let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            self.pushViewController(dashboardVC, animated: true)
        }
    }

    @objc func loadViewControllers(notification: NSNotification) {
        if let userInfo = notification.userInfo as? [String:Any] {
            if let storyboardId = userInfo[storyboardIdParam] as? String {
                if let selectedVC = self.storyboard?.instantiateViewController(withIdentifier: storyboardId) {
                    if let presentedVC = self.viewControllers.last {
                        if selectedVC.classForCoder == presentedVC.classForCoder {
                            // Nothing will do when click on same view controller
                        }
                        else {
                            // Set selected view controller in the navigation stack
                            self.setViewControllers([selectedVC], animated: true)
                        }
                    }
                }
            }
        }
    }

}
