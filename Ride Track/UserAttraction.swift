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
//    var attraction: AttractionsModel!
//    var park: ParksModel!

    var attractionID: Int!
    var parkID: Int!
    
    override init() {
    }
    
    init(attractionID: Int, parkID: Int) {
        self.attractionID = attractionID
        self.parkID = parkID
    }
}
