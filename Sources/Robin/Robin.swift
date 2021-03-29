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

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public class Robin {
    static var registrar = RobinActionRegistrar()
    public static let actions: RobinActions = registrar
    
    static var robinDelegate: RobinDelegate!
    public static var delegate: RobinDelegate {
        if robinDelegate == nil {
            robinDelegate = NotificationDelegate(registrar: registrar)
        }
        
        return robinDelegate
    }
    
    static var notificationCenterManager: RobinNotificationCenterManager!
    public static var manager: RobinNotificationCenterManager {
        if notificationCenterManager == nil {
            self.notificationCenterManager = NotificationCenterManager()
        }
        
        return self.notificationCenterManager
    }
    
    static var notificationsScheduler: RobinScheduler!
    public static var scheduler: RobinScheduler {
        if notificationsScheduler == nil {
            self.notificationsScheduler = NotificationsScheduler()
        }

        return self.notificationsScheduler
    }
    
    static var notificationsSettings: RobinSettingsManager!
    public static var settings: RobinSettingsManager {
        if notificationsSettings == nil {
            self.notificationsSettings = NotificationSettings()
        }
        
        return self.notificationsSettings
    }
}
