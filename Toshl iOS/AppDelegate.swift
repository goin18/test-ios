//
//  AppDelegate.swift
//  Toshl iOS
//
//  Created by Marko Budal on 24/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func from(#year:Int, month:Int, day:Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = NSTimeZone(abbreviation: "UTC")
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)!
        var date = gregorianCalendar.dateFromComponents(components)
        
        return date!
    }
    
    func initData(){
        var day1 = NSEntityDescription.insertNewObjectForEntityForName("DateDay", inManagedObjectContext: self.managedObjectContext!) as DateDay
        day1.date = from(year: 2015, month: 3, day: 30)
        day1.costs = 31.00
        day1.numberCost = 3
        
        var day2 = NSEntityDescription.insertNewObjectForEntityForName("DateDay", inManagedObjectContext: self.managedObjectContext!) as DateDay
        day2.date = from(year: 2015, month: 3, day: 29)
        day2.costs = 42.50
        day2.numberCost = 1

        var cost1 = NSEntityDescription.insertNewObjectForEntityForName("Cost", inManagedObjectContext: self.managedObjectContext!) as Cost
        cost1.name = "internet"
        cost1.category = "Home & Utilities"
        cost1.toAccount = "Bank"
        cost1.date = from(year: 2015, month: 3, day: 30)
        cost1.repeat = 1
        cost1.cost = 15.00
        
        var cost2 = NSEntityDescription.insertNewObjectForEntityForName("Cost", inManagedObjectContext: self.managedObjectContext!) as Cost
        cost2.name = "shop"
        cost2.category = "Home & Utilities"
        cost2.toAccount = "Bank"
        cost2.date = from(year: 2015, month: 3, day: 30)
        cost2.repeat = 1
        cost2.cost = 10.30
        
        var cost3 = NSEntityDescription.insertNewObjectForEntityForName("Cost", inManagedObjectContext: self.managedObjectContext!) as Cost
        cost3.name = "market"
        cost3.category = "Home & Utilities"
        cost3.toAccount = "Bank"
        cost3.date = from(year: 2015, month: 3, day: 30)
        cost3.repeat = 1
        cost3.cost = 5.70
        
        var cost4 = NSEntityDescription.insertNewObjectForEntityForName("Cost", inManagedObjectContext: self.managedObjectContext!) as Cost
        cost4.name = "skipass"
        cost4.category = "Home & Utilities"
        cost4.toAccount = "Bank"
        cost4.date = from(year: 2015, month: 3, day: 29)
        cost4.repeat = 1
        cost4.cost = 42.50
        
        var dayRelation1 = day1.mutableSetValueForKey("costsDay")
        dayRelation1.addObject(cost1)
        dayRelation1.addObject(cost2)
        dayRelation1.addObject(cost3)
        
        var dayRelation2 = day2.mutableSetValueForKey("costsDay")
        dayRelation2.addObject(cost4)
        
        self.saveContext()
        
    }
    
    func deleteAllObject(entityName: String){
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let objects = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil)
        
        for object in objects as [NSManagedObject] {
            self.managedObjectContext?.deleteObject(object)
        }
    }



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //pobrisi ze kreirane
       /* deleteAllObject("DateDay")
        deleteAllObject("Cost")
        initData()
*/
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "si.goin.mobileDev.Toshl_iOS" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Toshl_iOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Toshl_iOS.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

