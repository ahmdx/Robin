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

/// A protocol that represents objects responsible for handling the system's notification center delegation.
@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public protocol RobinDelegate {
    /// Asks Robin to process the response provided by the system's notification center. Robin examines the response for the `actionIdentifier`
    /// property and looks for its action handler in the registrar. If an action handler is found, it will be invoked to handle the response,
    /// as an instance of `RobinNotificationResponse`, and Robin will invoke the `completionHandler` afterwards.
    ///
    /// - attention:
    /// If you don't pass the completion handler provided by the system's notification center delegate, you will need to invoke it yourself.
    ///
    /// - Parameters:
    ///   - response: The system response.
    ///   - completionHandler: A callback to be called when Robin finishes processing the response.
    func didReceiveResponse(_ response: SystemNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
}
