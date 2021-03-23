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

class Date_Robin: XCTestCase {
    /// Tests whether `Date.next(minutes:)` succeeds.
    func testDateStaticNextMinutes() {
        let minutes: Int = 12
        
        XCTAssertEqual(Date.next(minutes: minutes).truncateSeconds(), Date().next(minutes: minutes).truncateSeconds())
    }
    
    /// Tests whether `Date().next(minutes:)` succeeds.
    func testDateNextMinutes() {
        let minutes: Int = 12
        let date: Date = Date().truncateSeconds()
        
        let dateAfterMinutes: Date = Calendar.current.date(byAdding: .minute, value: minutes, to: date)!.truncateSeconds()
        
        let testDate: Date = date.next(minutes: minutes)
        
        XCTAssertEqual(dateAfterMinutes, testDate)
    }
    
    /// Tests whether `Date.next(hours:)` succeeds.
    func testDateStaticNextHours() {
        let hours: Int = 12
        
        XCTAssertEqual(Date.next(hours: hours).truncateSeconds(), Date().next(hours: hours).truncateSeconds())
    }
    
    /// Tests whether `Date().next(hours:)` succeeds.
    func testDateNextHours() {
        let hours: Int = 12
        let date: Date = Date().truncateSeconds()
        let dateAfterHours: Date = Calendar.current.date(byAdding: .hour, value: hours, to: date)!.truncateSeconds()
        
        let testDate: Date = date.next(hours: hours)
        
        XCTAssertEqual(dateAfterHours, testDate)
    }
    
    /// Tests whether `Date.next(days:)` succeeds.
    func testDateStaticNextDays() {
        let days: Int = 12
        
        XCTAssertEqual(Date.next(days: days).truncateSeconds(), Date().next(days: days).truncateSeconds())
    }
    
    /// Tests whether `Date().next(days:)` succeeds.
    func testDateNextDays() {
        let days: Int = 12
        let date: Date = Date().truncateSeconds()
        
        let dateAfterDays: Date = Calendar.current.date(byAdding: .day, value: days, to: date)!.truncateSeconds()
        
        let testDate: Date = date.next(days: days)
        
        XCTAssertEqual(dateAfterDays, testDate)
    }
    
    /// Tests whether `Date.next(weeks:)` succeeds.
    func testDateStaticNextWeeks() {
        let weeks: Int = 12
        
        XCTAssertEqual(Date.next(weeks: weeks).truncateSeconds(), Date().next(weeks: weeks).truncateSeconds())
    }
    
    /// Tests whether `Date().next(weeks:)` succeeds.
    func testDateNextWeeks() {
        let weeks: Int = 12
        let date: Date = Date().truncateSeconds()
        
        let dateAfterWeeks: Date = Calendar.current.date(byAdding: .weekOfMonth, value: weeks, to: date)!.truncateSeconds()
        
        let testDate: Date = date.next(weeks: weeks)
        
        XCTAssertEqual(dateAfterWeeks, testDate)
    }
    
    /// Tests whether `Date.next(months:)` succeeds.
    func testDateStaticNextMonths() {
        let months: Int = 12
        
        XCTAssertEqual(Date.next(months: months).truncateSeconds(), Date().next(months: months).truncateSeconds())
    }
    
    /// Tests whether `Date().next(months:)` succeeds.
    func testDateNextMonths() {
        let months: Int = 12
        let date: Date = Date().truncateSeconds()
        
        let dateAfterMonths: Date = Calendar.current.date(byAdding: .month, value: months, to: date)!.truncateSeconds()
        
        let testDate: Date = date.next(months: months)
        
        XCTAssertEqual(dateAfterMonths, testDate)
    }
    
    /// Tests whether `Date.next(years:)` succeeds.
    func testDateStaticNextYears() {
        let years: Int = 12
        
        XCTAssertEqual(Date.next(years: years).truncateSeconds(), Date().next(years: years).truncateSeconds())
    }
    
    /// Tests whether `Date().next(years:)` succeeds.
    func testDateNextYears() {
        let years: Int = 12
        let date: Date = Date().truncateSeconds()
        
        let dateAfterYears: Date = Calendar.current.date(byAdding: .year, value: years, to: date)!.truncateSeconds()
        
        let testDate: Date = date.next(years: years)
        
        XCTAssertEqual(dateAfterYears, testDate)
    }
    
    /// Tests whether `Date().truncateSeconds()` succeeds.
    func testDateTruncateSeconds() {
        let date: Date = Date()
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: date)
        let dateWithoutSeconds: Date = calendar.date(from: components)!
        
        let testDate: Date = date.truncateSeconds()
        
        XCTAssertEqual(dateWithoutSeconds, testDate)
    }
    
    /// Tests whether `Date().dateWithTime()` succeeds.
    func testDateWithTime() {
        let time: Int = 0000
        let offset: Int = 60
        
        let calendar = Calendar.current
        var components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute], from: Date())
        components.minute = (time % 100) + offset % 60
        components.hour = (time / 100) + (offset / 60)
        var dateWithTime = calendar.date(from: components)!
        if dateWithTime < Date() {
            dateWithTime = dateWithTime.next(minutes: 60*24)
        }
        
        let testDate: Date = Date.date(withTime: 0000, offset: 60)
        
        XCTAssertEqual(dateWithTime, testDate)
    }
}
#endif
