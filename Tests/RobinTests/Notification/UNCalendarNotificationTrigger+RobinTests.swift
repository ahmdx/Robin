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

#if !os(watchOS)
import XCTest
@testable import Robin
import UserNotifications

@available(iOS 10.0, macOS 10.14, *)
class UNCalendarNotificationTrigger_RobinTests: XCTestCase {
    func testTriggerHourRepeats() {
        let date = Date().truncateSeconds()
        let trigger = UNCalendarNotificationTrigger(date: date, repeats: .hour)
        
        XCTAssertEqual(trigger.nextTriggerDate(), date.next(hours: 1))
    }
    
    func testTriggerDayRepeats() {
        let date = Date().truncateSeconds()
        let trigger = UNCalendarNotificationTrigger(date: date, repeats: .day)
        
        XCTAssertEqual(trigger.nextTriggerDate(), date.next(days: 1))
    }
    
    func testTriggerWeekRepeats() {
        let date = Date().truncateSeconds()
        let trigger = UNCalendarNotificationTrigger(date: date, repeats: .week)
        
        XCTAssertEqual(trigger.nextTriggerDate(), date.next(weeks: 1))
    }
    
    func testTriggerMonthRepeats() {
        let date = Date().truncateSeconds()
        let trigger = UNCalendarNotificationTrigger(date: date, repeats: .month)
        
        XCTAssertEqual(trigger.nextTriggerDate(), date.next(months: 1))
    }
}
#endif
