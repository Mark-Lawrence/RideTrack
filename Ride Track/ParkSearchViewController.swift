//
//  ParkSearchViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/17/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class ParkSearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    var parkArray:NSArray = NSArray()
    var selectedPark: ParksModel?
    
    //A list of parks searched for, to display in results table 
    var searchedParksList: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var searchTextFeild: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextFeild.becomeFirstResponder()
        self.searchTextFeild.delegate = self
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(parkArray.count)
        for i in 0..<parkArray.count {
            let park: ParksModel = parkArray[i] as! ParksModel
            if searchTextFeild.text == park.name{
                print("Match! \(park.name) ")
                searchedParksList.add(park)
            }
        }
        print(searchedParksList.count)
        
        for i in 0..<searchedParksList.count {
            let park: ParksModel = searchedParksList[i] as! ParksModel
            print(park.name)
        }
        //self.resultsTableView.reloadData()
        for i in 0..<searchedParksList.count {
            let park: ParksModel = searchedParksList[i] as! ParksModel
            print(park.name)
            //let newIndexPath = IndexPath(row: i, section: 0)
            //resultsTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedParksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellIdentifier = "searchedParkCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!
        let item: ParksModel = searchedParksList[indexPath.row] as! ParksModel
        myCell.textLabel!.text = item.name
        return myCell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "addNewParkToList") {
            if let indexPath = resultsTableView.indexPathForSelectedRow {
                selectedPark = (searchedParksList[indexPath.row] as! ParksModel)
            }
        }
        
        if (segue.identifier == "cancel") {
            print("CANCEL")
            selectedPark = nil
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
