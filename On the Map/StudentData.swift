//
//  StudentData.swift
//  On the Map
//
//  Created by Yu Qi Hao on 5/24/16.
//  Copyright © 2016 Yu Qi Hao. All rights reserved.
//

import Foundation

class StudentData {
    class func sharedLocations() -> [ParseLocation] {
        struct Singleton {
            static var locations = [ParseLocation]()
        }
        return Singleton.locations
    }
}
