//
//  ViewController.swift
//  On The Map
//
//  Created by lily on 7/27/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [usernameTextField, passWordTextField].forEach() {
            $0.delegate = self
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signUp(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityClient.Constants.Udacity.SignUpURL)!)
    }

    @IBAction func loginToUdacity(sender: UIButton) {
        UdacityClient.sharedInstance().getSessionID(usernameTextField.text!, password: passWordTextField.text!) { (success, sessionID, errorString) in
            performUIUpdatesOnMain {
                if success {
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigation") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                } else {
                    if let errorString = errorString {
                        self.showAlert(errorString)
                    }
                }
            }
        }
    }
    
    func  showAlert(errorString: String) {
        let alert = UIAlertController(title: "Login Failed", message: errorString, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}




