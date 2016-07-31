//
//  ViewController.swift
//  On The Map
//
//  Created by lily on 7/27/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBAction func loginToUdacity(sender: UIButton) {
        UdacityAPIHandling.sharedInstance.getSessionID(usernameTextField.text!, password: passWordTextField.text!) { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    print("got the session id")
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("ManageTabBarView") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


