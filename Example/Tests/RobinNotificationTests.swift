//
//  RobinNotificationTests.swift
//  Robin
//
//  Created by Ahmed Abdelbadie on 8/31/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
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
    
}
