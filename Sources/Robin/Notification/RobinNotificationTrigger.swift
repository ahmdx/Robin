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
#if !os(macOS)
import CoreLocation
#endif

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public enum RobinNotificationTrigger {
    case date(_ date: Date, repeats: RobinNotificationRepeats = .none)
    
    #if !os(macOS) && !os(watchOS)
    case location(_ region: CLRegion, repeats: Bool = false)
    #endif
}

@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
extension RobinNotificationTrigger: Equatable {
    public static func ==(lhs: RobinNotificationTrigger, rhs: RobinNotificationTrigger) -> Bool {
        if case .date(let lhsDate, let lhsRepeats) = lhs,
           case .date(let rhsDate, let rhsRepeats) = rhs {
            return lhsDate == rhsDate && lhsRepeats == rhsRepeats
        }
        
        #if !os(macOS) && !os(watchOS)
        if case .location(let lhsRegion, let lhsRepeats) = lhs,
           case .location(let rhsRegion, let rhsRepeats) = rhs {
            return lhsRegion == rhsRegion && lhsRepeats == rhsRepeats
        }
        #endif
        
        return false
    }
}
