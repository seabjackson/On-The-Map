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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.sharedInstance.sharedLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let studentDictionaryArray = StudentLocations.sharedInstance.sharedLocations[indexPath.row]
        let firstName = studentDictionaryArray.firstName! as String
        let lastName = studentDictionaryArray.lastName! as String
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.detailTextLabel?.text = "\(studentDictionaryArray.mapString)"
        cell.imageView!.image = UIImage(named: "pin")
        return cell
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
