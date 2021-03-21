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
class RobinNotificationGroupTests: XCTestCase {
    /// Tests whether the initialization of `RobinNotificationGroup` succeeds.
    func testNotificationGroupInitialization() {
        let notifications = [RobinNotification(body: "#1"), RobinNotification(body: "#2"), RobinNotification(body: "#3"), RobinNotification(body: "#4")]
        let group = RobinNotificationGroup(notifications: notifications)
        
        XCTAssertNotNil(group.identifier)
        
        XCTAssertNotNil(group.notifications)
        XCTAssertEqual(group.notifications.count, notifications.count)
        XCTAssertEqual(group.notifications, notifications)
        
        XCTAssertEqual(group.notifications[0].threadIdentifier, group.identifier)
        XCTAssertEqual(group.notifications[1].threadIdentifier, group.identifier)
        XCTAssertEqual(group.notifications[2].threadIdentifier, group.identifier)
        XCTAssertEqual(group.notifications[3].threadIdentifier, group.identifier)
    }
    
    /// Tests whether the initialization of `RobinNotificationGroup` with a custom identifier succeeds.
    func testNotificationGroupInitializationWithIdentifier() {
        let notifications = [RobinNotification(body: "#1"), RobinNotification(body: "#2"), RobinNotification(body: "#3"), RobinNotification(body: "#4")]
        let identifier = "Group"
        let group = RobinNotificationGroup(notifications: notifications, identifier: identifier)
        
        XCTAssertNotNil(group.identifier)
        XCTAssertEqual(group.identifier, identifier)
        
        XCTAssertNotNil(group.notifications)
        XCTAssertEqual(group.notifications.count, notifications.count)
        XCTAssertEqual(group.notifications, notifications)
        
        XCTAssertEqual(group.notifications[0].threadIdentifier, identifier)
        XCTAssertEqual(group.notifications[1].threadIdentifier, identifier)
        XCTAssertEqual(group.notifications[2].threadIdentifier, identifier)
        XCTAssertEqual(group.notifications[3].threadIdentifier, identifier)
    }
}
#endif
