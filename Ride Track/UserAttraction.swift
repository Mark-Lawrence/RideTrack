//
//  UserAttraction.swift
//  Ride Track
//
//  Created by Mark Lawrence on 4/23/18.
//  Copyright © 2018 Mark Lawrence. All rights reserved.
//

import UIKit

class UserAttraction: NSObject {
    //Should these iclude just ID numbers or the actual AttractionsModel and ParksModel classes?

    //Each time a new park is added, a new entry gets added to the 2D array that contains all rides in the park. When a ride is checked, the bool becomes true, else, default to false
    var rideID: Int!
    var parkID: Int!
    
    override init() {
    }
    
    init(rideID: Int, parkID: Int) {
        self.rideID = rideID
        self.parkID = parkID
    }
    
    init(parkID: Int) {
        self.parkID = parkID
    }

    
}
