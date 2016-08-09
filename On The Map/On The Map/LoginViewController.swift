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
        UdacityClient.sharedInstance().getSessionID(usernameTextField.text!, password: passWordTextField.text!) { (success, sessionID, errorString) in
            performUIUpdatesOnMain {
                if success {
                    print("got the session id")
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigation") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Login Failed", message: "Invalid username/password", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
}




