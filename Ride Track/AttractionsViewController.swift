//
//  AttractionsViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class AttractionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol {

    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    
    var titleName = ""
    var feedItems: NSArray = NSArray()
    var selectedAttraction: AttractionsModel = AttractionsModel()
    var parkID = 0
    //Do not like this
    var AttractionList: NSMutableArray = NSMutableArray()
    var userAttractionList: NSMutableArray = NSMutableArray()
    var userAttractionDatabase: [UserAttraction]!
    let green = UIColor(red: 120.0/255.0, green: 205.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor as CGColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkLabel.text = titleName
        self.attractionsTableView.delegate = self
        self.attractionsTableView.dataSource = self
        print(parkID)
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        
        let dataModel = DataModel()
        print ("There are ", userAttractionDatabase.count-1, " attactions in park ", parkID)
        dataModel.delegate = self

        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions")

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        for i in 1..<userAttractionDatabase.count{
            userAttractionList.add(feedItems[userAttractionDatabase[i].rideID])
        }
        for i in 0..<feedItems.count{
            AttractionList.add(feedItems[i])
            if i == (feedItems.count){
                break
            }
            
        }
        
        self.attractionsTableView.reloadData()
        print("THIS is the total num of attractions: ", feedItems.count)
        for j in 0..<feedItems.count{
            for i in 1..<userAttractionDatabase.count{ //THIS DOESNT WORK WHEN THERE ARE NO ATTRACTIONS AT A PARK
                if (userAttractionDatabase[i].rideID == j){
                    print ("We have ridden ride # ", userAttractionDatabase[i].rideID!)
                    //make array of rides ridden, and remove them from feedItems so they go on the bottom
                    AttractionList.remove(feedItems[j])
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AttractionList.count-userAttractionList.count //used to be feedItem
    }//TO MAKE IT SHOW SAVED ATTRACTIONS, MAKE THE RESTURN userAttractionList.count
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellIdentifier = "attractionCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!

       // let item: AttractionsModel = userAttractionList[indexPath.row] as! AttractionsModel //THIS SHOWS THE SAVED ATTRACTIONS**********************
        let item: AttractionsModel = AttractionList[indexPath.row] as! AttractionsModel //THIS WORKS FOR THE NOT COMPLETED ATTRACTION
        myCell.textLabel!.text = item.name
        myCell.textLabel?.textColor = UIColor.green
        
    
        myCell.textLabel!.text = item.name
                //I don't know if this would be the most effiecent way to check if the user has been on the ride?
       
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
