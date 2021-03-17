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
public struct RobinSettingsOptions: OptionSet, RawRepresentable {
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    #if !os(watchOS)
    public static let badge = RobinSettingsOptions(rawValue: 1 << 0)
    public static let lockScreen = RobinSettingsOptions(rawValue: 1 << 4)
    #endif
    
    public static let sound = RobinSettingsOptions(rawValue: 1 << 1)
    public static let alert = RobinSettingsOptions(rawValue: 1 << 2)
    public static let notificationCenter = RobinSettingsOptions(rawValue: 1 << 3)
    
    @available(iOS 12.0, *)
    public static let criticalAlert = RobinSettingsOptions(rawValue: 1 << 5)
    
    #if !os(macOS)
    #if !os(watchOS)
    public static let carPlay = RobinSettingsOptions(rawValue: 1 << 6)
    #endif
    
    @available(iOS 13.0, *)
    public static let announcement = RobinSettingsOptions(rawValue: 1 << 7)
    #endif
}
