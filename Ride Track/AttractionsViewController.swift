//
//  AttractionsViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class AttractionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeModelProtocol {

    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    
    var titleName = ""
    var feedItems: NSArray = NSArray()
    var selectedAttraction: AttractionsModel = AttractionsModel()
    var parkID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkLabel.text = titleName
        self.attractionsTableView.delegate = self
        self.attractionsTableView.dataSource = self
        
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        
        let homeModel = HomeModel()
        homeModel.delegate = self
        
        homeModel.downloadData(urlPath: urlPath, dataBase: "attractions")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.attractionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellIdentifier = "attractionCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!
        let item: AttractionsModel = feedItems[indexPath.row] as! AttractionsModel
        myCell.textLabel!.text = item.name
        
        return myCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
