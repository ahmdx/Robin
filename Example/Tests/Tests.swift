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
import XCTest
import Robin

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Robin.shared.cancelAll()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Robin.shared.cancelAll()
        super.tearDown()
    }
    
//    MARK:- RobinNotification
    
    /// Tests whether the initialization of `RobinNotification` succeeds.
    func testNotificationInitialization() {
        let body: String                    = "This is a test notification"
        let notification: RobinNotification = RobinNotification(body: body)
        
//        Tests body property
        XCTAssertEqual(body, notification.body)
        
//        Tests date property
        XCTAssertEqual(Date().next(hours: 1).removeSeconds(), notification.date.removeSeconds())
        let date: Date                      = Date()
        notification.date                   = date
        XCTAssertEqual(date, notification.date)
        
//        Tests repeats property
        XCTAssertEqual(Repeats.none, notification.repeats)
        let repeats: Repeats                = Repeats.month
        notification.repeats                = repeats
        XCTAssertEqual(repeats, notification.repeats)
        
//        Tests title property
        XCTAssertNil(notification.title)
        let title: String                   = "Title"
        notification.title                  = title
        XCTAssertEqual(title, notification.title)
        
//        Tests identifier property
        XCTAssertNotNil(notification.identifier)
        
//        Tests badge property
        XCTAssertNil(notification.badge)
        let badge: NSNumber                 = 5
        notification.badge                  = badge
        XCTAssertEqual(badge, notification.badge)
        
//        Tests userInfo property
        let userInfo: [AnyHashable : Any]   = [RobinNotification.identifierKey : notification.identifier]
        XCTAssertEqual(userInfo[RobinNotification.identifierKey] as! String, notification.userInfo![RobinNotification.identifierKey] as! String)
        
//        Tests sound property
        XCTAssertEqual(RobinNotification.defaultSoundName, notification.sound)
        let sound: String                   = "SoundName"
        notification.sound                  = sound
        XCTAssertEqual(sound, notification.sound)
        
//        Tests scheduled property
        XCTAssertFalse(notification.scheduled)
    }
    
    /// Tests whether the initialization of `RobinNotification` with a custom identifier succeeds.
    func testNotificationInitializationWithIdentifier() {
        let body: String                    = "This is a test notification"
        let identifier: String              = "Identifier"
        let notification: RobinNotification = RobinNotification(identifier: identifier, body: body)
        
        XCTAssertEqual(identifier, notification.identifier)
        XCTAssertEqual(body, notification.body)
    }
    
    /// Tests whether setting a `RobinNotification` userInfo key succeeds.
    func testNotificationUserInfoSet() {
        let notification: RobinNotification = RobinNotification(body: "Notification")
        
        let key: String                     = "Key"
        let value: String                   = "Value"
        notification.setUserInfo(value: value, forKey: key)
        
        XCTAssertEqual(value, notification.userInfo[key] as! String)
        
        notification.setUserInfo(value: value, forKey: RobinNotification.identifierKey)
        
        XCTAssertNotEqual(value, notification.userInfo[RobinNotification.identifierKey] as! String)
    }
    
    /// Tests whether setting a `RobinNotification` userInfo key succeeds.
    func testNotificationUserInfoRemove() {
        let notification: RobinNotification = RobinNotification(body: "Notification")
        
        let key: String                     = "Key"
        let value: String                   = "Value"
        notification.setUserInfo(value: value, forKey: key)
        
        notification.removeUserInfoValue(forKey: key)
        
        XCTAssertNil(notification.userInfo[key])
        
        notification.removeUserInfoValue(forKey: RobinNotification.identifierKey)
        
        XCTAssertEqual(notification.identifier, notification.userInfo[RobinNotification.identifierKey] as? String)
    }
    
    /// Tests whether initialized RobinNotifications have different identifiers.
    func testNotificationNonEquality() {
        let firstNotification: RobinNotification  = RobinNotification(body: "First Notification")
        let secondNotification: RobinNotification = RobinNotification(body: "Second Notification")
        
        let notEqual: Bool                        = firstNotification == secondNotification
        
        XCTAssertFalse(notEqual)
    }
    
    /// Tests whether testing for notification date precedence succeeds.
    func testNotificationDatePrecedence() {
        let firstNotification: RobinNotification  = RobinNotification(body: "First Notification", date: Date().next(minutes: 10))
        let secondNotification: RobinNotification = RobinNotification(body: "Second Notification", date: Date().next(hours: 1))
        
        let precedes: Bool                        = firstNotification < secondNotification
        
        XCTAssertTrue(precedes)
        
        firstNotification.date                    = Date().next(days: 1)
        
        let doesNotPrecede: Bool                  = firstNotification < secondNotification
        
        XCTAssertFalse(doesNotPrecede)
    }
    
//    MARK:- Robin
    
    /// Tests whether scheduling a `RobinNotification` succeeds.
    func testNotificationSchedule() {
        let notification          = RobinNotification(body: "This is a test notification")
        
        let scheduledNotification = Robin.shared.schedule(notification: notification)
        
        XCTAssertNotNil(scheduledNotification)
        XCTAssertTrue(notification.scheduled)
        XCTAssertTrue(scheduledNotification!.scheduled)
        XCTAssertEqual(1, Robin.shared.scheduledCount())
    }
    
    /// Tests whether scheduling multiple `RobinNotification`s succeeds.
    func testNotificationMultipleSchedule() {
        let count: Int = 15
        for i in 0 ..< count {
            let notification = RobinNotification(body: "This is test notification #\(i + 1)")
            
            let _ = Robin.shared.schedule(notification: notification)
        }
        
        XCTAssertEqual(count, Robin.shared.scheduledCount())
    }
    
    /// Tests whether scheduling a `RobinNotification` beyond the allowed maximum succeeds.
    func testNotificationScheduleOverAllowed() {
        let count: Int = Robin.maximumAllowedNotifications
        for i in 0 ..< count {
            let notification = RobinNotification(body: "This is test notification #\(i + 1)")
            
            let _ = Robin.shared.schedule(notification: notification)
        }
        
        let notification = RobinNotification(body: "This is an overflow notification")
        
        let overflowNotification = Robin.shared.schedule(notification: notification)
        
        XCTAssertNil(overflowNotification)
        XCTAssertFalse(notification.scheduled)
        XCTAssertEqual(count, Robin.shared.scheduledCount())
    }
    
    /// Tests whether rescheduling a `RobinNotification` beyond the allowed maximum succeeds.
    func testNotificationReschedule() {
        let date: Date              = Date().next(days: 1).removeSeconds()
        let notification            = RobinNotification(body: "This is a test notification")
        
        let _                       = Robin.shared.schedule(notification: notification)
        
        notification.date           = date
        
        let _                       = Robin.shared.reschedule(notification: notification)
        
        let rescheduledNotification = Robin.shared.notification(withIdentifier: notification.identifier)
        
        XCTAssertNotNil(rescheduledNotification)
        XCTAssertTrue(rescheduledNotification!.scheduled)
        XCTAssertEqual(rescheduledNotification!.date, notification.date)
        XCTAssertEqual(1, Robin.shared.scheduledCount())
    }
    
    /// Tests whether canceling a scheduled system notification succeeds.
    func testNotificationCancel() {
        let notification          = RobinNotification(body: "This is a test notification")
        
        let scheduledNotification = Robin.shared.schedule(notification: notification)
        
        Robin.shared.cancel(notification: scheduledNotification!)
        
        XCTAssertNotNil(scheduledNotification)
        XCTAssertFalse(notification.scheduled)
        XCTAssertFalse(scheduledNotification!.scheduled)
        XCTAssertEqual(0, Robin.shared.scheduledCount())
    }
    
    /// Tests whether canceling a scheduled system notification by identifier succeeds.
    func testNotificationIdentifierCancel() {
        let notification          = RobinNotification(body: "This is a test notification")
        
        let _ = Robin.shared.schedule(notification: notification)
        
        Robin.shared.cancel(withIdentifier: notification.identifier)
        
        XCTAssertTrue(notification.scheduled)
        XCTAssertEqual(0, Robin.shared.scheduledCount())
    }
    
    /// Tests whether canceling multiple scheduled system notifications by identifier succeeds.
    func testNotificationMultipleCancel() {
        let count: Int         = 15
        let identifier: String = "IDENTIFIER"
        for i in 0 ..< count {
            let notification = RobinNotification(identifier: identifier, body: "This is test notification #\(i + 1)")
            
            let _ = Robin.shared.schedule(notification: notification)
        }
        
        Robin.shared.cancel(withIdentifier: identifier)
        XCTAssertEqual(0, Robin.shared.scheduledCount())
    }
    
    /// Tests whether canceling all scheduled system notifications succeeds.
    func testCancelAll() {
        let count: Int = 15
        for i in 0 ..< count {
            let notification = RobinNotification(body: "This is test notification #\(i + 1)")
            
            let _ = Robin.shared.schedule(notification: notification)
        }
        
        Robin.shared.cancelAll()
        
        XCTAssertEqual(0, Robin.shared.scheduledCount())
    }
    
    /// Tests whether retrieving a scheduled system notification by identifier succeeds.
    func testNotificationWithIdentifier() {
        let notification          = RobinNotification(body: "This is a test notification")
        notification.title        = "This is a test title"
        notification.badge        = 1
        notification.repeats      = .week
        
        let _                     = Robin.shared.schedule(notification: notification)
        
        let retrievedNotification = Robin.shared.notification(withIdentifier: notification.identifier)
        
        XCTAssertEqual(retrievedNotification?.title, notification.title)
        XCTAssertEqual(retrievedNotification?.identifier, notification.identifier)
        XCTAssertEqual(retrievedNotification?.body, notification.body)
        XCTAssertEqual(retrievedNotification?.date, notification.date.removeSeconds())
        XCTAssertEqual(retrievedNotification?.userInfo.count, notification.userInfo.count)
        XCTAssertEqual(retrievedNotification?.badge, notification.badge)
        XCTAssertEqual(retrievedNotification?.sound, notification.sound)
        XCTAssertEqual(retrievedNotification?.repeats, notification.repeats)
        XCTAssertEqual(retrievedNotification?.scheduled, notification.scheduled)
        XCTAssertTrue(retrievedNotification!.scheduled)
        XCTAssertEqual(1, Robin.shared.scheduledCount())
    }
    
//    MARK:- Date+Scheduler
    
    /// Tests whether `Date.next(minutes:)` succeeds.
    func testDateNextMinutes() {
        let minutes: Int               = 12
        let date: Date                 = Date()
        
        let calendar: Calendar         = Calendar.current
        var components: DateComponents = DateComponents()
        components.minute              = minutes
        let dateAfterMinutes: Date     = (calendar as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))!
        
        let testDate: Date             = date.next(minutes: minutes)
        
        XCTAssertEqual(dateAfterMinutes, testDate)
    }
    
    /// Tests whether `Date.next(hours:)` succeeds.
    func testDateNextHours() {
        let hours: Int           = 12
        let date: Date           = Date()
        let dateAfterHours: Date = Date().next(minutes: hours * 60)
        
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
