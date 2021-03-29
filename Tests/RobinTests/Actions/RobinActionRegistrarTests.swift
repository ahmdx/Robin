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
import XCTest
@testable import Robin

@available(iOS 10.0, macOS 10.14, *)
class RobinActionRegistrarTests: XCTestCase {
    struct ActionOne: RobinActionHandler {
        func handle(response: RobinNotificationResponse) {
        }
    }
    
    struct ActionTwo: RobinActionHandler {
        func handle(response: RobinNotificationResponse) {
        }
    }
    
    /// Tests whether registering action handlers succeeds.
    func testRegisterActionHandlers() {
        let registrar = RobinActionRegistrar()
        
        registrar.register(actionHandler: ActionOne.self, forIdentifier: "ACTION_ONE")
        registrar.register(actionHandler: ActionTwo.self, forIdentifier: "ACTION_TWO")
        
        XCTAssertEqual(registrar.registeredActions.count, 2)
        XCTAssert(registrar.action(forIdentifier: "ACTION_ONE") is ActionOne.Type)
        XCTAssert(registrar.action(forIdentifier: "ACTION_TWO") is ActionTwo.Type)
    }
    
    /// Tests whether de-registering action handlers succeeds.
    func testDeregisterActionHandlers() {
        let registrar = RobinActionRegistrar()
        
        registrar.register(actionHandler: ActionOne.self, forIdentifier: "ACTION_ONE")
        registrar.register(actionHandler: ActionTwo.self, forIdentifier: "ACTION_TWO")
        
        XCTAssertEqual(registrar.registeredActions.count, 2)
        XCTAssert(registrar.action(forIdentifier: "ACTION_ONE") is ActionOne.Type)
        XCTAssert(registrar.action(forIdentifier: "ACTION_TWO") is ActionTwo.Type)
        
        registrar.deregister(actionHandlerForIdentifier: "ACTION_ONE")
        XCTAssertEqual(registrar.registeredActions.count, 1)
        XCTAssertNil(registrar.action(forIdentifier: "ACTION_ONE"))
        XCTAssert(registrar.action(forIdentifier: "ACTION_TWO") is ActionTwo.Type)
    }
}
#endif
