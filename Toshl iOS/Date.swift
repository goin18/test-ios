//
//  Date.swift
//  Toshl iOS
//
//  Created by Marko Budal on 25/03/15.
//  Copyright (c) 2015 Marko Budal. All rights reserved.
//

import Foundation

class Date {
    
    class func from(#year:Int, month:Int, day:Int) -> NSDate {
        
        var components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.timeZone = NSTimeZone(abbreviation: "UTC")
        
        var gregorianCalendar = NSCalendar(identifier: NSGregorianCalendar)!
        var date = gregorianCalendar.dateFromComponents(components)
        return date!
    }
    
    class func toString(#date:NSDate) -> String {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "dd. MMM yyyy"//"yyyy-MM-dd"
        let dateString = dateStringFormatter.stringFromDate(date)
        
        return dateString

    }
    
    class func getDateMounth(#date: NSDate) -> Int {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "MM"
        let dateString:String = dateStringFormatter.stringFromDate(date)
        let mounth:Int = dateString.toInt()!
        
        return mounth
    }
    
    class func getDateDay(#date: NSDate) -> Int {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "dd"
        let dateString:String = dateStringFormatter.stringFromDate(date)
        let day:Int = dateString.toInt()!
        
        return day
    }

}
