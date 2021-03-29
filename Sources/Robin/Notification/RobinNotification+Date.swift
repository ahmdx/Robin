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

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
extension RobinNotification {
    /// Since repeating a `UNCalendarNotificationTrigger` nullifies some of the
    /// date components, the original date needs to be stored. Robin stores this date
    /// in the notification's `userInfo` property using `Constants.NotificationKeys.date`.
    /// This original date is used to fill those nullified components.
    ///
    /// - Parameters:
    ///   - dateComponents: The `UNCalendarNotificationTrigger` date components.
    ///   - repeats: The repeat interval of the trigger.
    ///   - originalDate: The original date stored to fill the nullified components. Uses current date if passed as `nil`.
    /// - Returns: The filled date using the original date.
    internal static func date(fromDateComponents dateComponents: DateComponents, repeats: RobinNotificationRepeats, originalDate: Date?) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = dateComponents
        
        let date = originalDate ?? Date()
        
        switch repeats {
        case .none:
            return calendar.date(from: components)!
        case .month:
            let comps = calendar.dateComponents([.year, .month], from: date)
            components.year = comps.year
            components.month = comps.month
            
            return calendar.date(from: components)!
        case .week: fallthrough
        case .day:
            let comps = calendar.dateComponents([.year, .month, .day], from: date)
            components.year = comps.year
            components.month = comps.month
            components.day = comps.day
            
            return calendar.date(from: components)!
        case .hour:
            let comps = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            components.year = comps.year
            components.month = comps.month
            components.day = comps.day
            components.hour = comps.hour
            
            return calendar.date(from: components)!
        }
    }
}
