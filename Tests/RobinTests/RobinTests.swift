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

@available(iOS 10.0, macOS 10.14, *)
class RobinTests: XCTestCase {
    override class func setUp() {
        let center = RobinNotificationCenterMock()
        let scheduler = UserNotificationsScheduler(center: center)
        let manager = NotificationCenterManager(center: center)
        
        Robin.notificationsScheduler = scheduler
        Robin.notificationCenterManager = manager
    }
    
    override class func tearDown() {
        Robin.notificationsScheduler = nil
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Robin.scheduler.cancelAll()
        Robin.manager.removeAllDelivered()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Robin.scheduler.cancelAll()
        Robin.manager.removeAllDelivered()
        super.tearDown()
    }
    
    /// Tests whether requesting authorization succeeds.
    func testRequestAuthorization() {
        let expectation = XCTestExpectation()
        
        Robin.scheduler.requestAuthorization(forOptions: [.alert]) { grant, error in
            XCTAssertTrue(grant)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Tests whether scheduling a `RobinNotification` succeeds.
    func testNotificationSchedule() {
        let notification = RobinNotification(body: "This is a test notification")
        
        let scheduledNotification = Robin.scheduler.schedule(notification: notification)
        
        XCTAssertNotNil(scheduledNotification)
        XCTAssertTrue(notification.scheduled)
        XCTAssertTrue(scheduledNotification!.scheduled)
        XCTAssertEqual(1, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether scheduling multiple `RobinNotification`s succeeds.
    func testNotificationMultipleSchedule() {
        let count: Int = 15
        for i in 0 ..< count {
            let notification = RobinNotification(body: "This is a test notification #\(i + 1)")
            
            let _ = Robin.scheduler.schedule(notification: notification)
        }
        
        XCTAssertEqual(count, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether scheduling a `RobinNotification` beyond the allowed maximum succeeds.
    func testNotificationScheduleOverAllowed() {
        let count: Int = Constants.maximumAllowedNotifications
        for i in 0 ..< count {
            let notification = RobinNotification(body: "This is a test notification #\(i + 1)")
            
            let _ = Robin.scheduler.schedule(notification: notification)
        }
        
        let notification = RobinNotification(body: "This is an overflow notification")
        
        let overflowNotification = Robin.scheduler.schedule(notification: notification)
        
        XCTAssertNil(overflowNotification)
        XCTAssertFalse(notification.scheduled)
        XCTAssertEqual(count, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether rescheduling a `RobinNotification` beyond the allowed maximum succeeds.
    func testNotificationReschedule() {
        let date: Date = Date().next(days: 1).truncateSeconds()
        let notification = RobinNotification(body: "This is a test notification")
        
        let _ = Robin.scheduler.schedule(notification: notification)
        
        notification.date = date
        
        let _ = Robin.scheduler.reschedule(notification: notification)
        
        let rescheduledNotification = Robin.scheduler.notification(withIdentifier: notification.identifier)
        
        XCTAssertNotNil(rescheduledNotification)
        XCTAssertTrue(rescheduledNotification!.scheduled)
        XCTAssertEqual(rescheduledNotification!.date, notification.date)
        XCTAssertEqual(1, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether canceling a scheduled system notification succeeds.
    func testNotificationCancel() {
        let notification = RobinNotification(body: "This is a test notification")
        
        let scheduledNotification = Robin.scheduler.schedule(notification: notification)
        
        Robin.scheduler.cancel(notification: scheduledNotification!)
        
        XCTAssertNotNil(scheduledNotification)
        XCTAssertFalse(notification.scheduled)
        XCTAssertFalse(scheduledNotification!.scheduled)
        XCTAssertEqual(0, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether canceling a scheduled system notification by identifier succeeds.
    func testNotificationIdentifierCancel() {
        let notification = RobinNotification(body: "This is a test notification")
        
        let _ = Robin.scheduler.schedule(notification: notification)
        
        Robin.scheduler.cancel(withIdentifier: notification.identifier)
        
        XCTAssertTrue(notification.scheduled)
        XCTAssertEqual(0, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether canceling multiple scheduled system notifications by identifier succeeds.
    func testNotificationMultipleCancel() {
        let count: Int = 15
        let identifier: String = "IDENTIFIER"
        for i in 0 ..< count {
            let notification = RobinNotification(identifier: identifier, body: "This is a test notification #\(i + 1)")
            
            let _ = Robin.scheduler.schedule(notification: notification)
        }
        
        Robin.scheduler.cancel(withIdentifier: identifier)
        
        XCTAssertEqual(0, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether canceling all scheduled system notifications succeeds.
    func testCancelAll() {
        let count: Int = 15
        for i in 0 ..< count {
            let notification = RobinNotification(body: "This is a test notification #\(i + 1)")
            
            let _ = Robin.scheduler.schedule(notification: notification)
        }
        
        Robin.scheduler.cancelAll()
        
        XCTAssertEqual(0, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether retrieving a scheduled system notification by identifier succeeds.
    func testNotificationWithIdentifier() {
        let notification = RobinNotification(body: "This is a test notification")
        notification.title = "This is a test title"
        notification.badge = 1
        notification.repeats = .week
        notification.sound = RobinNotificationSound(named: "TestSound")
        notification.setUserInfo(value: "Value", forKey: "Key")
        
        let _ = Robin.scheduler.schedule(notification: notification)
        
        let retrievedNotification = Robin.scheduler.notification(withIdentifier: notification.identifier)
        
        XCTAssertEqual(retrievedNotification?.title, notification.title)
        XCTAssertEqual(retrievedNotification?.identifier, notification.identifier)
        XCTAssertEqual(retrievedNotification?.body, notification.body)
        XCTAssertEqual(retrievedNotification?.date, notification.date.truncateSeconds())
        XCTAssertEqual(retrievedNotification?.userInfo.count, notification.userInfo.count)
        XCTAssertEqual(retrievedNotification?.badge, notification.badge)
        XCTAssertTrue(notification.sound.isValid())
        XCTAssertEqual(retrievedNotification?.repeats, notification.repeats)
        XCTAssertEqual(retrievedNotification?.scheduled, notification.scheduled)
        XCTAssertTrue(retrievedNotification!.scheduled)
        XCTAssertEqual(1, Robin.scheduler.scheduledCount())
    }
    
    /// Tests whether retrieving all delivered system notifications succeeds.
    func testGetDeliveredNotification() {
        let count: Int = 1
        
        let notification = RobinNotification(body: "This is a test notification")
        notification.date = Date().next(days: 1)
        
        let _ = Robin.scheduler.schedule(notification: notification)
        
        let expectation = XCTestExpectation()
        
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(count, notifications.count)
            
            let retrievedNotification = notifications[0]
            
            XCTAssertEqual(retrievedNotification.title, notification.title)
            XCTAssertEqual(retrievedNotification.identifier, notification.identifier)
            XCTAssertEqual(retrievedNotification.body, notification.body)
            XCTAssertNotEqual(retrievedNotification.date, notification.date.truncateSeconds())
            XCTAssertEqual(retrievedNotification.userInfo.count, notification.userInfo.count)
            XCTAssertEqual(retrievedNotification.badge, notification.badge)
            XCTAssertTrue(notification.sound.isValid())
            XCTAssertEqual(retrievedNotification.repeats, notification.repeats)
            XCTAssertEqual(retrievedNotification.scheduled, notification.scheduled)
            XCTAssertTrue(retrievedNotification.scheduled)
            XCTAssertTrue(retrievedNotification.delivered)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    /// Tests whether removing a delivered notification succeeds.
    func testRemoveDeliveredNotification() {
        let notification = RobinNotification(body: "This is a test notification")
        let anotherNotification = RobinNotification(body: "This is another test notification")
        
        let _ = Robin.scheduler.schedule(notification: notification)
        let _ = Robin.scheduler.schedule(notification: anotherNotification)
        
        let deliveryExpectation = XCTestExpectation()
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(2, notifications.count)
            deliveryExpectation.fulfill()
        }
        
        Robin.manager.removeDelivered(notification: notification)
        
        let removalExpectation = XCTestExpectation()
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(1, notifications.count)
            removalExpectation.fulfill()
        }
        
        wait(for: [deliveryExpectation, removalExpectation], timeout: 5.0)
    }
    
    /// Tests whether removing a delivered system notification by identifier succeeds.
    func testRemoveDeliveredNotificationByIdentifier() {
        let notification = RobinNotification(body: "This is a test notification")
        let anotherNotification = RobinNotification(body: "This is another test notification")
        
        let _ = Robin.scheduler.schedule(notification: notification)
        let _ = Robin.scheduler.schedule(notification: anotherNotification)
        
        let deliveryExpectation = XCTestExpectation()
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(2, notifications.count)
            deliveryExpectation.fulfill()
        }
        
        Robin.manager.removeDelivered(withIdentifier: notification.identifier)
        
        let removalExpectation = XCTestExpectation()
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(1, notifications.count)
            removalExpectation.fulfill()
        }
        
        wait(for: [deliveryExpectation, removalExpectation], timeout: 5.0)
    }
    
    /// Tests whether removing all delivered system notifications succeeds.
    func testRemoveAllDeliveredNotifications() {
        let notification = RobinNotification(body: "This is a test notification")
        let anotherNotification = RobinNotification(body: "This is another test notification")
        
        let _ = Robin.scheduler.schedule(notification: notification)
        let _ = Robin.scheduler.schedule(notification: anotherNotification)
        
        let deliveryExpectation = XCTestExpectation()
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(2, notifications.count)
            deliveryExpectation.fulfill()
        }
        
        Robin.manager.removeAllDelivered()
        
        let removalExpectation = XCTestExpectation()
        Robin.manager.allDelivered { notifications in
            XCTAssertEqual(0, notifications.count)
            removalExpectation.fulfill()
        }
        
        wait(for: [deliveryExpectation, removalExpectation], timeout: 5.0)
    }
}
