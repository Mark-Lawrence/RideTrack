//
//  ViewController.swift HELLOOOOO
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//  last pushed: May 8, 1:30
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
    //var userAttractionDatabase: [[UserAttractionProvider]]! = [[UserAttractionProvider(parkID: 31), UserAttractionProvider(rideID: 4, parkID: 31), UserAttractionProvider(rideID: 8, parkID: 31)],[UserAttractionProvider(parkID: 32) ,UserAttractionProvider(rideID: 70, parkID: 32)]]
    
    var userAttractionDatabase: [[UserAttractionProvider]] = [[]]
    
    var userAttractionProvider: UserAttractionProvider? = nil
    var userAttractions: [NSManagedObject] = []
    
    override func viewDidLoad() {
        
        //Add temp data
//        self.save(parkID: 31, rideID: 4)
//        self.save(parkID: 32, rideID: 70)
//         self.save(parkID: 31, rideID: 8)
        //self.save(parkID: 32, rideID: 75)
        
        
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
    override func viewWillAppear(_ animated: Bool) {
        
        print("VIEW WILL APPEAR RAN")
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "rideID", ascending: true)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RideTrack")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userAttractions = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func itemsDownloaded(items: NSArray) {
        dataMigrationToList()
        
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
    
    func save(parkID: Int, rideID: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "RideTrack",
                                                in: managedContext)!
        
        let newPark = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        newPark.setValue(parkID, forKeyPath: "parkID")
        newPark.setValue(rideID, forKeyPath: "rideID")
        print("Just saved new park: ", parkID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
            self.save(parkID: newPark.parkID, rideID: 0)
            print("new park saved: ", newPark.parkID)
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
        print("THis is size of UserAttractions: ", userAttractions.count)
        for i in 0..<userAttractions.count {
            let person = userAttractions[i]
            print("SAVED ITEM: \(person.value(forKeyPath: "rideID")!)")
        }
        print(stringToPrint)
    }
    
    
    func dataMigrationToList() {
       var firstTime = true
        var parkIndex = 0
        for i in 0..<userAttractions.count {
            let ride = userAttractions[i]
            var rideNext = userAttractions[i]
            if i != userAttractions.count - 1{
                rideNext = userAttractions[i+1]
            }
            else{
                rideNext = userAttractions[i]
            }
            print("SAVED ITEM: \(ride.value(forKeyPath: "rideID")!)")
            
            let compare1 = ride.value(forKeyPath: "parkID") as! Int
            let compare2 = rideNext.value(forKeyPath: "parkID") as! Int
            
//            if firstTime{
//                //userAttractionDatabase[parkIndex].append(UserAttractionProvider(parkID: compare1))
//                userAttractionDatabase.append([UserAttractionProvider(parkID: compare1)])
//                firstTime = false
//            }
            userAttractionDatabase[parkIndex].append(UserAttractionProvider(rideID: ride.value(forKeyPath: "rideID") as! Int, parkID: compare1))
            
            if compare1 != compare2 && i != userAttractions.count - 1{
                parkIndex += 1
                userAttractionDatabase.append([UserAttractionProvider(parkID: compare2)])
            }
        }
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

