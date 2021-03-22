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

public struct Constants {
    /// The maximum allowed notifications to be scheduled at a time by iOS.
    ///- Important: Do not change this value. Changing this value to be over
    /// 64 will cause some notifications to be discarded by iOS.
    internal static let maximumAllowedSystemNotifications = 64
    /// The maximum number of allowed notifications to be scheduled. Four slots
    /// are reserved if you would like to schedule notifications without them being dropped
    /// due to unavailable notification slots.
    ///> Feel free to change this value.
    ///
    ///- attention:
    /// iOS by default allows a maximum of 64 notifications to be scheduled at a time.
    ///
    ///- seealso: `Constants.maximumAllowedSystemNotifications`
    public static var maximumAllowedNotifications = 60
    
    public struct NotificationKeys {
        /// Holds the date of the notification; stored in the `userInfo` property.
        public static let date = "RobinNotificationDateKey"
    }
    
    public struct NotificationValues {
        /// Used to represent iOS default notification sound name.
        public static let defaultSoundName = "RobinNotificationDefaultSound"
    }
}
