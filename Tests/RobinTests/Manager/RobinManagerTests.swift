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

@available(iOS 10.0, macOS 10.14, *)
class RobinManagerTests: XCTestCase {
    override class func setUp() {
        let center = RobinNotificationCenterMock()
        let scheduler = NotificationsScheduler(center: center)
        let manager = NotificationCenterManager(center: center)
        
        Robin.notificationsScheduler = scheduler
        Robin.notificationCenterManager = manager
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
    
    /// Tests whether retrieving all delivered system notifications succeeds.
    func testGetDeliveredNotification() {
        let count: Int = 1
        
        let notification = RobinNotification(body: "This is a test notification")
        notification.date = Date().next(days: 1)
        
        _ = Robin.scheduler.schedule(notification: notification)
        
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
        
        _ = Robin.scheduler.schedule(notification: notification)
        _ = Robin.scheduler.schedule(notification: anotherNotification)
        
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
        
        _ = Robin.scheduler.schedule(notification: notification)
        _ = Robin.scheduler.schedule(notification: anotherNotification)
        
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
        
        _ = Robin.scheduler.schedule(notification: notification)
        _ = Robin.scheduler.schedule(notification: anotherNotification)
        
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
#endif
