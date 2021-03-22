//
// Copyright (c) 2017 Ahmed Mohamed <dev@ahmd.pro>
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

import Foundation

/// An enum that represents the repeat interval of the notification.
///
/// - .none: The notification should never repeat.
/// - .hour: The notification should repeat every hour.
/// - .day: The notification should repeat every day.
/// - .week: The notification should repeat every week.
/// - .month: The notification should repeat every month.
@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public enum RobinNotificationRepeats: String {
    case none = "None"
    case hour = "Hour"
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    internal static func from(dateComponents components: DateComponents) -> RobinNotificationRepeats {
        if self.doesRepeatNone(dateComponents: components) {
            return .none
        }
        
        if doesRepeatMonth(dateComponents: components) {
            return .month
        }
        
        if doesRepeatWeek(dateComponents: components) {
            return .week
        }
        
        if doesRepeatDay(dateComponents: components) {
            return .day
        }
        
        if doesRepeatHour(dateComponents: components) {
            return .hour
        }
        
        return .none
    }
    
    fileprivate static func doesRepeatNone(dateComponents components: DateComponents) -> Bool {
        return components.year != nil && components.month != nil && components.day != nil && components.hour != nil && components.minute != nil
    }
    
    fileprivate static func doesRepeatMonth(dateComponents components: DateComponents) -> Bool {
        return components.day != nil && components.hour != nil && components.minute != nil
    }
    
    fileprivate static func doesRepeatWeek(dateComponents components: DateComponents) -> Bool {
        return components.weekday != nil && components.hour != nil && components.minute != nil && components.second != nil
    }
    
    fileprivate static func doesRepeatDay(dateComponents components: DateComponents) -> Bool {
        return components.hour != nil && components.minute != nil && components.second != nil
    }
    
    fileprivate static func doesRepeatHour(dateComponents components: DateComponents) -> Bool {
        return components.minute != nil && components.second != nil
    }
}
