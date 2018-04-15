//
//  ViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/14/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataModelProtocol {

    @IBOutlet weak var listTableView: UITableView!
    
    var feedItems: NSArray = NSArray()
    var selectedPark: ParksModel = ParksModel()
    var parkID = 2
    var titleTest = "test"
    
    override func viewDidLoad() {
        listTableView.isUserInteractionEnabled = true
        super.viewDidLoad()
        self.listTableView.delegate = self
        self.listTableView.dataSource = self
        
        let urlPath = "http://www.beingpositioned.com/theparksman/parksdbservice.php"

        let dataModel = DataModel()
        dataModel.delegate = self
        
        dataModel.downloadData(urlPath: urlPath, dataBase: "parks")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCellIdentifier = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: myCellIdentifier)!
        let item: ParksModel = feedItems[indexPath.row] as! ParksModel
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
            selectedPark = feedItems[selectedIndex!] as! ParksModel
            print(attractionVC.parkID)
            attractionVC.titleName = selectedPark.name
            attractionVC.parkID = selectedPark.parkID
            
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

