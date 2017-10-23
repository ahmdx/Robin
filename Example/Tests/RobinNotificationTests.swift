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

import XCTest
import Robin

class RobinNotificationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        let userInfo: [AnyHashable : Any]   = [RobinNotification.identifierKey : notification.identifier, RobinNotification.dateKey : notification.date]
        XCTAssertEqual(userInfo[RobinNotification.identifierKey] as! String, notification.userInfo![RobinNotification.identifierKey] as! String)
        XCTAssertEqual(userInfo[RobinNotification.dateKey] as! Date, notification.userInfo![RobinNotification.dateKey] as! Date)
        
        //        Tests sound property
        XCTAssertTrue(notification.sound.isValid())
        let sound: String                   = "SoundName"
        notification.sound                  = RobinNotificationSound(named: sound)
        XCTAssertTrue(notification.sound.isValid())
        
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
    
}
