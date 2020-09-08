//
// Copyright (c) 2017 Ahmed Abdelbadie <badie.ahmed@icloud.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit
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
            date = date.next(days: 1)
        }
        
        return date
    }
}
