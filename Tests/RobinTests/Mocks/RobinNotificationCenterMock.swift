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
import UserNotifications
@testable import Robin

@available(iOS 10.0, macOS 10.14, *)
class RobinNotificationCenterMock: RobinNotificationCenter {
    fileprivate var requests: [String : UNNotificationRequest] = [:]
    fileprivate var deliveredNotifications: [String : DeliveredSystemNotification] = [:]
    var settings = SystemNotificationSettingsMock()
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        completionHandler(true, nil)
    }
    
    func getSettings(completionHandler: @escaping (SystemNotificationSettings) -> Void) {
        completionHandler(settings)
    }
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        requests[request.identifier] = request
        deliveredNotifications[request.identifier] = DeliveredSystemNotificationMock(request: request)
        
        completionHandler?(nil)
    }
    
    func getPendingNotificationRequests(completionHandler: @escaping ([UNNotificationRequest]) -> Void) {
        completionHandler(requests.values.map({ $0 }))
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        requests.removeValue(forKey: identifiers[0])
    }
    
    func removeAllPendingNotificationRequests() {
        requests = [:]
    }
    
    func getDelivered(completionHandler: @escaping ([DeliveredSystemNotification]) -> Void) {
        completionHandler(deliveredNotifications.values.map({ $0 }))
    }
    
    func removeDeliveredNotifications(withIdentifiers identifiers: [String]) {
        deliveredNotifications.removeValue(forKey: identifiers[0])
    }
    
    func removeAllDeliveredNotifications() {
        deliveredNotifications = [:]
    }
}
#endif
