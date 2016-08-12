//
//  MapTabBarViewController.swift
//  On The Map
//
//  Created by lily on 8/9/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit

class MapTabBarViewController: UITabBarController {
    
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().deleteSessionID() {(success, error) in
            if success {
                performUIUpdatesOnMain() {
                    let controller = (self.storyboard?.instantiateViewControllerWithIdentifier("LoginScreen"))! as UIViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
