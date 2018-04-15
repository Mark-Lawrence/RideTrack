//
//  TestViewController.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/15/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var parksLabel: UILabel!
    var parkID = 0
    var titleName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(parkID)
        parksLabel.text = titleName
        print(self)
        // Do any additional setup after loading the view.
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
