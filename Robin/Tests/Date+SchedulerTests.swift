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

import XCTest
@testable import Robin

class Date_SchedulerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Tests whether `Date.next(minutes:)` succeeds.
    func testDateNextMinutes() {
        let minutes: Int               = 12
        let date: Date                 = Date().removeSeconds()
        
        let calendar: Calendar         = Calendar.current
        var components: DateComponents = DateComponents()
        components.minute              = minutes
        let dateAfterMinutes: Date     = (calendar as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))!.removeSeconds()
        
        let testDate: Date             = date.next(minutes: minutes)
        
        XCTAssertEqual(dateAfterMinutes, testDate)
    }
    
    /// Tests whether `Date.next(hours:)` succeeds.
    func testDateNextHours() {
        let hours: Int           = 12
        let date: Date           = Date().removeSeconds()
        let dateAfterHours: Date = Date().next(minutes: hours * 60).removeSeconds()
        
        let testDate: Date       = date.next(hours: hours)
        
        XCTAssertEqual(dateAfterHours, testDate)
    }
    
    /// Tests whether `Date.next(days:)` succeeds.
    func testDateNextDays() {
        let days: Int           = 12
        let date: Date          = Date().removeSeconds()
        let dateAfterDays: Date = Date().next(minutes: days * 60 * 24).removeSeconds()
        
        let testDate: Date      = date.next(days: days)
        
        XCTAssertEqual(dateAfterDays, testDate)
    }
    
    /// Tests whether `Date.removeSeconds()` succeeds.
    func testDateRemoveSeconds() {
        let date: Date               = Date()
        
        let calendar                 = Calendar.current
        let components               = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: date)
        let dateWithoutSeconds: Date = calendar.date(from: components)!
        
        let testDate: Date           = date.removeSeconds()
        
        XCTAssertEqual(dateWithoutSeconds, testDate)
    }
    
    /// Tests whether `Date.dateWithTime()` succeeds.
    func testDateWithTime() {
        let time: Int      = 0000
        let offset: Int    = 60
        
        let calendar       = Calendar.current
        var components     = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: Date())
        components.minute  = (time % 100) + offset % 60
        components.hour    = (time / 100) + (offset / 60)
        var dateWithTime   = calendar.date(from: components)!
        if dateWithTime < Date() {
            dateWithTime   = dateWithTime.next(minutes: 60*24)
        }
        
        let testDate: Date = Date.date(withTime: 0000, offset: 60)
        
        XCTAssertEqual(dateWithTime, testDate)
    }
    
}
