//
//  DateTimeModules.swift
//  Office Forest App
//
//  Created by student on 7/6/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import Foundation

extension NSDate
{
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
    
    func year() -> Int {
        //get year
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: self)
        let year = components.year
        
        return year
    }
    
    func month() -> Int {
        //get year
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Month, fromDate: self)
        let month = components.month
        
        return month
    }
    
    func days() -> Int {
        //get year
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: self)
        let day = components.day
        
        return day
    }
    
    func toFullString() -> String {
        let dd = self.days().as2digit()
        let mm = self.month().as2digit()
        let yy = self.year().as4digit()
        let hh = self.hour().as2digit()
        let mn = self.minute().as2digit()
        
        let fullstring = "\(dd)/\(mm)/\(yy) \(hh):\(mn)"
        return fullstring
    }
}

extension Int {
    func as2digit() -> String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func as4digit() -> String {
        var rem = "\(self)"
        
        if self < 10 {
            rem = "0\(rem)"
        }
        
        if self < 100 {
            rem = "0\(rem)"
        }
        
        if self < 1000 {
            rem = "0\(rem)"
        }
        
        return rem
    }
    

}

//func getNSDate(timestamp: String) -> NSDate? {
//    let dd = timestamp.getSubs(0, end: 2)
//    let mm = timestamp.getSubs(3, end: 5)
//    let yy = timestamp.getSubs(6, end: 10)
//    let hh = timestamp.getSubs(11, end: 13)
//    let mn = timestamp.getSubs(14, end: 16)
//    
// 
//    
//}