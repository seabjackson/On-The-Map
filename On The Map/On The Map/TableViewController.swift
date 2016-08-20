//
//  TableViewController.swift
//  On The Map
//
//  Created by lily on 7/29/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.sharedInstance.sharedLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let firstName = StudentLocations.sharedInstance.sharedLocations[indexPath.row].firstName,lastName = StudentLocations.sharedInstance.sharedLocations[indexPath.row].lastName {
            cell.textLabel?.text = "\(firstName) \(lastName)"
            cell.imageView!.image = UIImage(named: "pin")
        }
        return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: StudentLocations.sharedInstance.sharedLocations[indexPath.row].mediaURL!) {
            app.openURL(url)
        } else {
            showAlert("Invalid Link", withMessage: "")
        }
        
    }
    
    // refresh the tableView
    func didRefreshTable() {
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain() {
                if error != nil {
                    self.showAlert("Fetching Error", withMessage: "error retrieving location")
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    func  showAlert(title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
