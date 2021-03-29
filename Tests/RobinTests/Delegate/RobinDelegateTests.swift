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
class RobinDelegateTests: XCTestCase {
    static var action: ((RobinNotificationResponse) -> Void)?
    
    struct ActionOne: RobinActionHandler {
        func handle(response: RobinNotificationResponse) {
            action?(response)
        }
    }
    
    /// Tests whether calling the `didReceive` method with a registered action handler succeeds.
    func testDidReceiveResponse() {
        let actionExpectation = XCTestExpectation()
        RobinDelegateTests.action = { response in
            XCTAssertNotNil(response)
            XCTAssertNotNil(response.notification)
            
            actionExpectation.fulfill()
        }
        
        let handlerExpectation = XCTestExpectation()
        let completionHandler = {
            handlerExpectation.fulfill()
        }
        
        let identifier = "ACTION_ONE"
        Robin.actions.register(actionHandler: ActionOne.self, forIdentifier: identifier)
        
        let notification = RobinNotification(body: "A notification")
        let response = SystemNotificationResponseMock(robinNotification: notification, actionIdentifier: identifier)
        
        Robin.delegate.didReceiveResponse(response, withCompletionHandler: completionHandler)
        
        wait(for: [actionExpectation, handlerExpectation], timeout: 5.0)
    }
    
    /// Tests whether calling the `didReceive` method with a user-provided text and a registered action handler succeeds.
    func testDidReceiveTextResponse() {
        let userText = "A text"
        
        let actionExpectation = XCTestExpectation()
        RobinDelegateTests.action = { response in
            XCTAssertEqual(response.userText, userText)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response.notification)
            
            actionExpectation.fulfill()
        }
        
        let handlerExpectation = XCTestExpectation()
        let completionHandler = {
            handlerExpectation.fulfill()
        }
        
        let identifier = "ACTION_ONE"
        Robin.actions.register(actionHandler: ActionOne.self, forIdentifier: identifier)
        
        let notification = RobinNotification(body: "A notification")
        let response = SystemNotificationTextResponseMock(robinNotification: notification, actionIdentifier: identifier, userText: userText)
        
        Robin.delegate.didReceiveResponse(response, withCompletionHandler: completionHandler)
        
        wait(for: [actionExpectation, handlerExpectation], timeout: 5.0)
    }
    
    /// Tests whether calling the `didReceive` method with a non-registered action handler succeeds.
    func testDidReceiveResponseNoRegisteredActionHandler() {
        let expectation = XCTestExpectation()
        let completionHandler = {
            expectation.fulfill()
        }
        
        let identifier = "ACTION_ONE"
        let notification = RobinNotification(body: "A notification")
        let response = SystemNotificationResponseMock(robinNotification: notification, actionIdentifier: identifier)
        
        Robin.delegate.didReceiveResponse(response, withCompletionHandler: completionHandler)
        
        wait(for: [expectation], timeout: 5.0)
    }
}
#endif
