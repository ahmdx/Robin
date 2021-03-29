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

import UserNotifications

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public protocol SystemNotificationResponse {
    var robinNotification: RobinNotification { get }
    var actionIdentifier: String { get }
    
    func robinNotificationResponse() -> RobinNotificationResponse
}

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public extension SystemNotificationResponse {
    func robinNotificationResponse() -> RobinNotificationResponse {
        return RobinNotificationResponse(notification: self.robinNotification)
    }
}

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public protocol SystemNotificationTextResponse: SystemNotificationResponse {
    var userText: String { get }
    
    func robinNotificationTextResponse() -> RobinNotificationResponse
}

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public extension SystemNotificationTextResponse {
    func robinNotificationTextResponse() -> RobinNotificationResponse {
        return RobinNotificationResponse(notification: self.robinNotification, userText: self.userText)
    }
}
