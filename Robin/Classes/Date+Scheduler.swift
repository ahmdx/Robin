//
//  Date+Scheduler.swift
//  Pods
//
//  Created by Ahmed Mohamed on 8/26/17.
//
//

import Foundation

public extension Date {
    
    /// Adds a number of minutes to a date.
    /// > This method can add and subtract minutes.
    ///
    /// - Parameter minutes: The number of minutes to add/subtract.
    /// - Returns: The date after the minutes addition/subtraction.
    func next(minutes: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.minute = minutes
        return (calendar as NSCalendar).date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))!
    }
    
    /// Adds a number of hours to a date.
    /// > This method can add and subtract hours.
    ///
    /// - Parameter hours: The number of hours to add/subtract.
    /// - Returns: The date after the hours addition/subtraction.
    func next(hours: Int) -> Date {
        return self.next(minutes: hours * 60)
    }
    
    /// Adds a number of days to a date.
    /// >This method can add and subtract days.
    ///
    /// - Parameter days: The number of days to add/subtract.
    /// - Returns: The date after the days addition/subtraction.
    func next(days: Int) -> Date {
        return self.next(minutes: days * 60 * 24)
    }
    
    /// Removes the seconds component from the date.
    ///
    /// - Returns: The date after removing the seconds component.
    func removeSeconds() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: components)!
    }
    
    /// Creates a date object with the given time and offset. The offset is used to align the time with the GMT.
    ///
    /// - Parameters:
    ///   - time: The required time of the form HHMM.
    ///   - offset: The offset in minutes.
    /// - Returns: Date with the specified time and offset.
    static func date(withTime time: Int, offset: Int) -> Date {
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: Date())
        components.minute = (time % 100) + offset % 60
        components.hour = (time / 100) + (offset / 60)
        var date = calendar.date(from: components)!
        if date < Date() {
            date = date.next(minutes: 60*24)
        }
        
        return date
    }
}
