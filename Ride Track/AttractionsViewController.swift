//
//  AttractionsViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
// Pushed may 8, 5:40

import UIKit
import CoreData



class AttractionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol {
    
    @IBOutlet weak var attractionsTableView: UITableView!
    @IBOutlet weak var parkLabel: UILabel!
    
    var titleName = ""
    var tempAttraction: AttractionsModel = AttractionsModel()
    var parkID = 0
    //Do not like this
    var attractionListForTable: NSMutableArray = [AttractionsModel()]
    var userAttractionDatabase: [UserAttractionProvider]!
    
    var startOfList: Int = 0
    let green = UIColor(red: 120.0/255.0, green: 205.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor as CGColor
    var userAttractions: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parkLabel.text = titleName
        self.attractionsTableView.delegate = self
        self.attractionsTableView.dataSource = self
        print(parkID)
        let urlPath = "http://www.beingpositioned.com/theparksman/attractiondbservice.php?parkid=\(parkID)"
        let dataModel = DataModel()
        // print ("There are ", feedItems.count, " attactions in park ", parkID)
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "attractions")
        // Do any additional setup after loading the view, typically from a nib.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let alertController = UIAlertController(title: "Attraction added", message: "The attraction has been saved", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .destructive) { (action:UIAlertAction) in
            print("You've pressed the ok button");
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        
        print ("Seclected Attraction is: ", (attractionListForTable[indexPath.row] as! AttractionsModel).attractionID)
        (attractionListForTable[indexPath.row] as! AttractionsModel).isCheck = true
        self.save(parkID: parkID, rideID: (attractionListForTable[indexPath.row] as! AttractionsModel).attractionID)
        
        userAttractionDatabase.append(UserAttractionProvider(rideID: (attractionListForTable[indexPath.row] as! AttractionsModel).attractionID, parkID: parkID))

        //print("SAVED ITEM: \(person.value(forKeyPath: "rideID")!)")
    }
    
    func itemsDownloaded(items: NSArray) {
        for i in 0..<items.count{
            attractionListForTable.add(items[i])
        }
        
        self.attractionsTableView.reloadData()
        
        startOfList = (items.firstObject as! AttractionsModel).attractionID
        
        for j in startOfList..<items.count+startOfList {
            for i in 1..<userAttractionDatabase.count{
                if (userAttractionDatabase[i].rideID == j){
                    print ("We have ridden ride # ", userAttractionDatabase[i].rideID!)
                    (attractionListForTable[j-startOfList+1] as! AttractionsModel).isCheck = true
                    break
                }
            }
        }
        attractionListForTable.removeObject(at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionListForTable.count-1//used to be feedItem
    }//TO MAKE IT SHOW SAVED ATTRACTIONS, MAKE THE RESTURN userAttractionList.count
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCellIdentifier = "attractionCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!
        let item: AttractionsModel = attractionListForTable[indexPath.row] as! AttractionsModel
        if ((attractionListForTable[indexPath.row] as! AttractionsModel).isCheck){
            myCell.textLabel?.textColor = UIColor.green
        }
        else{
            myCell.textLabel?.textColor = UIColor.black
        }
        myCell.textLabel!.text = item.name
        
        return myCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print("Just saved Attraction: ", rideID)
        do {
            try managedContext.save()
            userAttractions.append(newPark)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
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
