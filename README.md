# Robin

[![Platform](https://img.shields.io/cocoapods/p/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Version](https://img.shields.io/cocoapods/v/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Swift 4+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)](https://swift.org)
[![CI Status](http://img.shields.io/travis/ahmdx/Robin.svg)](https://travis-ci.org/ahmdx/Robin)
[![License](https://img.shields.io/github/license/ahmdx/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Release](https://img.shields.io/github/release/ahmdx/Robin.svg)](https://github.com/ahmdx/Robin/releases/)

Robin is a notification interface for iOS and macOS that handles UserNotifications behind the scenes.

## Requirements

- iOS 10.0+
- macOS 10.14+
- Xcode 10.0+
- Swift 4.2+

## Communication

- If you need help or have a question, use 'robin' tag on [Stack Overflow](http://stackoverflow.com/questions/tagged/robin).
- If you found a bug or have a feature request, please open an issue.

Please do not open a pull request until a contribution guide is published.

## Installation

Robin is available through both [Swift Package Manager](https://swift.org/package-manager/) and [CocoaPods](http://cocoapods.org).

To install using SPM:

```swift
.package(url: "https://github.com/ahmdx/Robin", from: "0.91.0"),
```

CocoaPods:

```ruby
pod 'Robin', '~> 0.91.0'
```

And if you want to include the test suite in your project:

```ruby
pod 'Robin', '~> 0.91.0', :testspecs => ['Tests']
```

## Usage

```swift
import Robin
```

Before using `Robin`, you need to request permission to send notifications to users. The following requests `badge`, `sound`, and `alert` permissions.

```swift
Robin.scheduler.requestAuthorization(forOptions: [.badge, .sound, .alert]) { grant, error in
  // Handle authorization or error
}
```

### Notifications

Scheduling iOS notifications via `Robin` is carried over by manipulating `RobinNotification` objects. To create a `RobinNotification` object, simply call its initializer.

```swift
init(identifier: String = default, body: String, date: Date = default)
```

Example notification, with a unique identifier, to be fired an hour from now.

```swift
let notification = RobinNotification(body: "A notification", date: Date().next(hours: 1))
```

> `next(minutes:)`, `next(hours:)`, and `next(days:)` are part of a `Date` extension.

The following table summarizes all `RobinNotification` properties.

| Property | Type | Description |
| --- | --- | --- |
| badge | `NSNumber?` | The number the notification should display on the app icon. |
| body | `String!` | The body string of the notification. |
| date | `Date!` | The date in which the notification is set to fire on. |
| identifier<sup>[1]</sup> | `String!` | A string assigned to the notification for later access. |
| repeats | `Repeats` | The repeat interval of the notification. One of `none` (default), `hour`, `day`, `week`, or `month`.|
| scheduled | `Bool` | The status of the notification. `read-only` |
| delivered | `Bool` | The delivery status of the notification. `read-only` |
| sound | `RobinNotificationSound` | The sound name of the notification. |
| title | `String?` | The title string of the notification. |
| userInfo<sup>[2]</sup> | `[AnyHashable : Any]!` | A dictionary that holds additional information. |

[1] `identifier` is read-only after `RobinNotification` is initialized.

[2] To add and remove keys in `userInfo`, use `setUserInfo(value: Any, forKey: AnyHashable)` and `removeUserInfoValue(forKey: AnyHashable)` respectively.

### Schedule a notification

After creating a `RobinNotification` object, it can be scheduled using `schedule(notification:)`.

```swift
let scheduledNotification = Robin.scheduler.schedule(notification: notification)
```

Now `scheduledNotification` is a valid `RobinNotification` object if it is successfully scheduled or `nil` otherwise.

### Retrieve a notification

Simply retrieve a scheduled notification by calling `notification(withIdentifier: String) -> RobinNotification?`.

```swift
let scheduledNotification = Robin.scheduler.notification(withIdentifier: "identifier")
```

### Cancel a notification

To cancel a notification, either call `cancel(notification: RobinNotification)` or `cancel(withIdentifier: String)`

```swift
Robin.scheduler.cancel(notification: scheduledNotification)
```

```swift
Robin.scheduler.cancel(withIdentifier: scheduledNotification.identifier)
```

`Robin` allows you to cancel all scheduled notifications by calling `cancelAll()`

```swift
Robin.scheduler.cancelAll()
```

### Retrieve all delivered notifications

To retrieve all delivered notifications that are displayed in the notification center, call `allDelivered(completionHandler: @escaping ([RobinNotification]) -> Void)`.

```swift
Robin.manager.allDelivered { deliveredNotifications in
  // Access delivered notifications
}
```

### Remove a delivered notification

To remove a delivered notification from the notification center, either call `removeDelivered(notification: RobinNotification)` or `removeDelivered(withIdentifier identifier: String)`.

```swift
Robin.manager.removeDelivered(notification: deliveredNotification)
```

```swift
Robin.manager.removeDelivered(withIdentifier: deliveredNotification.identifier)
```

`Robin` allows you to remove all delivered notifications by calling `removeAllDelivered()`

```swift
Robin.manager.removeAllDelivered()
```

## Notes

`Robin` is preset to allow 60 notifications to be scheduled by iOS. The remaining four slots are kept for the app-defined notifications. These free slots are currently not handled by `Robin`; if you use `Robin` to utilize these slots, the notifications will be discarded. To change the maximum allowed, just update `Robin.maximumAllowedNotifications`.

`Robin` currently can't handle multiple notifications with the same identifier. Support for grouping notifications under the same identifier is coming soon.

## Author

Ahmed Mohamed, dev@ahmd.pro

## License

Robin is available under the MIT license. See the [LICENSE](https://github.com/ahmdx/Robin/blob/master/LICENSE) file for more info.
