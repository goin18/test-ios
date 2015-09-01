//
//  Cost.swift
//  Toshl iOS
//
//  Created by Marko Budal on 30/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation
import CoreData

@objc (Cost)
class Cost: NSManagedObject {

    @NSManaged var category: String
    @NSManaged var cost: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var name: String
    @NSManaged var repeat: NSNumber
    @NSManaged var toAccount: String
    @NSManaged var dayCost: DateDay

}
