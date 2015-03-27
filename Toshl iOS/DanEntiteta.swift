//
//  DanEntiteta.swift
//  Toshl iOS
//
//  Created by Marko Budal on 27/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation
import CoreData

@objc (DanEntiteta)
class DanEntiteta: NSManagedObject {

    @NSManaged var dan: NSDate
    @NSManaged var skupniStroski: NSNumber
    @NSManaged var costnumber: NSNumber

}
