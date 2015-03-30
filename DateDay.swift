//
//  DateDay.swift
//  Toshl iOS
//
//  Created by Marko Budal on 30/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation
import CoreData

@objc (DateDay)
class DateDay: NSManagedObject {

    @NSManaged var costs: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var numberCost: NSNumber
    @NSManaged var costsDay: NSSet

}
