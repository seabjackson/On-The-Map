//
//  MapTabBarViewController.swift
//  On The Map
//
//  Created by lily on 8/9/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit


class MapTabBarViewController: UITabBarController {
    

    
    @IBAction func refreshButtonPressed(sender: UIBarButtonItem) {
        if viewControllers![selectedIndex].isKindOfClass(MapViewController) {
            let controller = selectedViewController as! MapViewController
            controller.didRefreshMap()
        } else {
            let controller = selectedViewController as! TableViewController
            controller.didRefreshTable()
        }
    }
    
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSessionID() {(success, error) in
            if success {
                performUIUpdatesOnMain() {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }

}
