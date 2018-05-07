//
//  ViewController.swift HELLOOOOO
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
//removed
    var feedItems: NSArray = NSArray()
    var selectedPark: ParksModel = ParksModel()
    var parkID = 2
    var titleTest = "test"
    var usersParkList: NSMutableArray = NSMutableArray()
    //First entry in the array will always be just the parkID? Not ideal
    var userAttractionDatabase: [[UserAttractionProvider]]! = [[UserAttractionProvider(parkID: 31), UserAttractionProvider(rideID: 4, parkID: 31), UserAttractionProvider(rideID: 8, parkID: 31)],[UserAttractionProvider(parkID: 32) ,UserAttractionProvider(rideID: 70, parkID: 32)]]
     var userAttractionProvider: UserAttractionProvider? = nil
    
    override func viewDidLoad() {
        
        listTableView.isUserInteractionEnabled = true
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        print(usersParkList.count)
        if usersParkList.count != 0{
            print(usersParkList[usersParkList.count - 1])
        }
        else{
            print("user parks list is empty")
        }
        
        //Initialize Note contentProvider
        
        let urlPath = "http://www.beingpositioned.com/theparksman/parksdbservice.php"

        let dataModel = DataModel()
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "parks")
        
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        
        //Adds parks the user has already saved to the table list
        for i in 0..<userAttractionDatabase.count{
            
            //Needs to be changed to match parkID, not index?
            //**MARK FIX THIS***
            usersParkList.add(feedItems[userAttractionDatabase[i][0].parkID])
        }
        printUserDatabase()
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return feedItems.count
        return usersParkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellIdentifier = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!
        //let item: ParksModel = feedItems[indexPath.row] as! ParksModel
        let item: ParksModel = usersParkList[indexPath.row] as! ParksModel
        myCell.textLabel!.text = item.name
        

        return myCell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toAttractions"{
            let attractionVC = segue.destination as! AttractionsViewController
            let selectedIndex = listTableView.indexPathForSelectedRow?.row
            //selectedPark = feedItems[selectedIndex!] as! ParksModel
            selectedPark = usersParkList[selectedIndex!] as! ParksModel
            attractionVC.titleName = selectedPark.name
            attractionVC.parkID = selectedPark.parkID
            if userAttractionDatabase != nil{
                for i in 0..<userAttractionDatabase.count {
                    if userAttractionDatabase[i][0].parkID == selectedPark.parkID{
                        print("match!")
                       // attractionVC.userAttractionDatabase = userAttractionDatabase[i]
                        attractionVC.userAttractionDatabase = userAttractionDatabase[i]
                    }
                    else{
                        print("never been to this park yet")
                    }
                }
            }
            else{
                print("array is empty")
            }
        }
        
        if segue.identifier == "toSearch"{
            let searchVC = segue.destination as! ParkSearchViewController
            searchVC.parkArray = feedItems
        }
    }
    
    @IBAction func unwindToParkList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ParkSearchViewController, let newPark = sourceViewController.selectedPark{
            usersParkList.add(newPark)
            userAttractionDatabase.append([UserAttractionProvider(parkID: newPark.parkID)])
            printUserDatabase()
            self.listTableView.reloadData()
        }
    }
    
    func printUserDatabase() {
        var stringToPrint = "Current user database:"
        for i in 0..<userAttractionDatabase.count{
            //Kind of funcky, but the first entry will always just be the parkID? I don't know how good of an idea this is...
            stringToPrint += "\n\nPark ID: \(userAttractionDatabase[i][0].parkID!):\n"
            for j in 1..<userAttractionDatabase[i].count{
                stringToPrint += "RideID: \(userAttractionDatabase[i][j].rideID!)  "
            }
            if userAttractionDatabase[i].count == 1{
                stringToPrint += "Empty"
            }
        }
        print(stringToPrint)
    }

    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//
//        if (segue.identifier == "toAttractions"){
//            let attractionVC = segue.destination as! AttractionsViewController
//            let selectedIndex = listTableView.indexPathForSelectedRow?.row
//            selectedPark = feedItems[selectedIndex!] as! ParksModel
//            let name = selectedPark.name
//            let parkID = selectedPark.parkID
//            attractionVC.parkLabel.text = titleTest
//            //attractionVC.parkID = parkID!
//        }
//    }
}

