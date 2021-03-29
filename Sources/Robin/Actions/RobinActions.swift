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

/// A protocol that represents objects that handle `RobinActionHandler` registration and de-registration.
@available(iOS 10.0, watchOS 3.0, macOS 10.14, *)
public protocol RobinActions {
    /// Registers a `RobinActionHandler` type to be used to handle a user notification action having the specified identifier.
    ///
    /// - Parameters:
    ///   - action: The `RobinActionHandler` type to register.
    ///   - identifier: The identifier of the user notification action.
    func register(actionHandler: RobinActionHandler.Type, forIdentifier identifier: String)
    
    /// Deregisters the `RobinActionHandler` type registered for the specified user notification action identifier.
    ///
    /// - Parameter identifier: The identifier of the user notification action.
    func deregister(actionHandlerForIdentifier identifier: String)
}
