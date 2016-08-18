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
        return sharedLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let firstName = sharedLocations[indexPath.row].firstName,lastName = sharedLocations[indexPath.row].lastName {
            cell.textLabel?.text = "\(firstName) \(lastName)"
            cell.imageView!.image = UIImage(named: "pin")
        }
        return cell
    }
//    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: sharedLocations[indexPath.row].mediaURL!) {
            app.openURL(url)
        }
        
    }
    
    // refresh the tableView
    func didRefreshTable() {
        ParseClient.sharedInstance().getStudentLocation() { (success, error) in
            performUIUpdatesOnMain() {
                if let error = error {
                    print("An error occured \(error)")
                }
                print("refreshed the table")
                self.tableView.reloadData()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
