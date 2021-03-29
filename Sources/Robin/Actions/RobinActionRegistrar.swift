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

/// An object that registers and deregisters `RobinActionHandler`s used to handle notification actions.
@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
internal class RobinActionRegistrar: RobinActions {
    fileprivate(set) internal var registeredActions: [String : RobinActionHandler.Type] = [:]
    
    func register(actionHandler: RobinActionHandler.Type, forIdentifier identifier: String) {
        self.registeredActions[identifier] = actionHandler
    }
    
    func deregister(actionHandlerForIdentifier identifier: String) {
        self.registeredActions[identifier] = nil
    }
    
    /// Returns the registered `RobinActionHandler` type for the specified identifier.
    ///
    /// - Parameter identifier: The identifier of the user notification action.
    /// - Returns: The `RobinActionHandler` type if it exists.
    func action(forIdentifier identifier: String) -> RobinActionHandler.Type? {
        return self.registeredActions[identifier]
    }
}
