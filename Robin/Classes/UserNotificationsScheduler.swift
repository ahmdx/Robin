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

import Foundation

internal class UserNotificationsScheduler: Scheduler {
    func requestAuthorization(forOptions options: RobinAuthorizationOptions) {
    }
    
    func schedule(notification: RobinNotification) -> RobinNotification? {
        if notification.scheduled == true {
            return nil
        }
        
        if (self.scheduledCount() >= Robin.maximumAllowedNotifications) {
            return nil
        }
        
        return nil
    }
    
    func reschedule(notification: RobinNotification) -> RobinNotification? {
        self.cancel(notification: notification)
        
        return self.schedule(notification: notification)
    }
    
    func cancel(notification: RobinNotification) {
        if notification.scheduled == false {
            return
        }
    }
    
    func cancel(withIdentifier identifier: String) {
    }
    
    func cancelAll() {
        print("All scheduled system notifications have been canceled.")
    }
    
    func notification(withIdentifier identifier: String) -> RobinNotification? {
        return nil
    }
    
    func scheduledCount() -> Int {
        return 0
    }
    
    //    MARK:- Testing
    
    func printScheduled() {
    }
}
