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

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
extension RobinNotification: CustomStringConvertible {
    public var description: String {
        var result = ""
        result += "RobinNotification: \(self.identifier!)\n"
        if let title = self.title {
            result += "\tTitle: \(title)\n"
        }
        if let threadIdentifier = threadIdentifier {
            result += "\tThread identifier: \(threadIdentifier)\n"
        }
        result += "\tBody: \(self.body!)\n"
        if let trigger = self.trigger,
           case let RobinNotificationTrigger.date(date, repeats) = trigger {
            result += "\tFires at: \(date)\n"
            result += "\tRepeats every: \(repeats.rawValue)\n"
        }
        
        #if !os(macOS) && !os(watchOS)
        if let trigger = self.trigger,
           case let RobinNotificationTrigger.location(region, repeats) = trigger {
            result += "\tFires around: \(region)\n"
            result += "\tRepeating: \(repeats)\n"
        }
        #endif
        
        result += "\tUser info: \(self.userInfo)\n"
        if let badge = self.badge {
            result += "\tBadge: \(badge)\n"
        }
        #if !os(watchOS)
        result += "\tSound name: \(self.sound)\n"
        #endif
        result += "\tScheduled: \(self.scheduled)\n"
        result += "\tDelivered: \(self.delivered)"
        if let deliveryDate = deliveryDate {
            result += "\n\tDelivered on: \(deliveryDate)"
        }
        
        return result
    }
}
