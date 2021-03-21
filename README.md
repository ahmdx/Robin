
[![Platform](https://img.shields.io/cocoapods/p/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Version](https://img.shields.io/cocoapods/v/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Swift 4+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)](https://swift.org)
[![CI Status](http://img.shields.io/travis/ahmdx/Robin.svg)](https://travis-ci.org/ahmdx/Robin)
[![License](https://img.shields.io/github/license/ahmdx/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Release](https://img.shields.io/github/release/ahmdx/Robin.svg)](https://github.com/ahmdx/Robin/releases/)

Robin is a multi-platform notification interface for iOS, watchOS, and macOS that handles UserNotifications behind the scenes.

- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
  - [Settings](#settings)
  - [Notifications](#notifications)
  - [Schedule a notification](#schedule-a-notification)
  - [Retrieve a notification](#retrieve-a-notification)
  - [Cancel a notification](#cancel-a-notification)
  - [Schedule a notification group](#schedule-a-notification-group)
  - [Retrieve a notification group](#retrieve-a-notification-group)
  - [Cancel a notification group](#cancel-a-notification-group)
  - [Retrieve all delivered notifications](#retrieve-all-delivered-notifications)
  - [Remove a delivered notification](#remove-a-delivered-notification)
- [Notes](#notes)
- [Author](#author)
- [License](#license)

## Requirements

- iOS 10.0+
- watchOS 3.0+
- macOS 10.14+
- Xcode 11.1+
- Swift 4.2+

## Communication

- If you need help or have a question, use 'robin' tag on [Stack Overflow](http://stackoverflow.com/questions/tagged/robin).
- If you found a bug or have a feature request, please open an issue.

Please do not open a pull request until a contribution guide is published.

## Installation

Robin is available through both [Swift Package Manager](https://swift.org/package-manager/) and [CocoaPods](http://cocoapods.org).

To install using SPM:

```swift
.package(url: "https://github.com/ahmdx/Robin", from: "0.96.0"),
```

CocoaPods:

```ruby
pod 'Robin', '~> 0.96.0'
```

And if you want to include the test suite in your project:

```ruby
pod 'Robin', '~> 0.96.0', :testspecs => ['Tests']
```

## Usage

```swift
import Robin
```

Before using `Robin`, you need to request permission to send notifications to users. The following requests `badge`, `sound`, and `alert` permissions. For all available options, refer to [UNAuthorizationOptions](https://developer.apple.com/documentation/usernotifications/unauthorizationoptions).

```swift
Robin.settings.requestAuthorization(forOptions: [.badge, .sound, .alert]) { grant, error in
  // Handle authorization or error
}
```

### Settings

To query for the app's notification settings, you can use `Robin.settings`:

```swift
let alertStyle = Robin.settings.alertStyle
```

> Note: `alertStyle` is not available on watchOS.

```swift
let authorizationStatus = Robin.settings.authorizationStatus
```

```swift
let enabledSettings = Robin.settings.enabledSettings
```

> Note: This returns an option set of all the enabled settings. If some settings are not included in the set, they may be disabled or not supported. If you would like to know if some specific setting is enabled, you can use `enabledSettings.contains(.sound)` for example. For more details, refer to `RobinSettingsOptions`.

```swift
let showPreviews = Robin.settings.showPreviews
```

> Note: `showPreviews` is not available on watchOS.

Robin automatically updates information about the app's settings when the app goes into an inactive state and becomes active again to avoid unnecessary queries. If you would like to override this behavior and update the information manually, you can use `forceRefresh()`.

```swift
Robin.settings.forceRefresh()
```

> Note: Robin on watchOS does not support automatic settings refresh.

### Notifications

Scheduling notifications via `Robin` is carried over by manipulating `RobinNotification` objects. To create a `RobinNotification` object, simply call its initializer.

```swift
init(identifier: String = default, body: String, trigger: RobinNotificationTrigger = default)
```

Example notification, with a unique identifier, to be fired an hour from now.

```swift
let notification = RobinNotification(body: "A notification", trigger: .date(.next(hours: 1)))
```

> Note: `next(minutes:)`, `next(hours:)`, and `next(days:)` are part of a `Date` extension.

Example notification, with a unique identifier, to be fired when entering a region.

```swift
/// https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger
let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
region.notifyOnEntry = true
region.notifyOnExit = false

let notification = RobinNotification(body: "A notification", trigger: .location(region))
```

> Note: For the system to deliver location notifications, the app should be authorized to use location services, see [here](https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger). *Robin does not check whether the required permissions are granted before scheduling a location notification.*

The following table summarizes all `RobinNotification` properties.

| Property | Type | Description |
| --- | --- | --- |
| badge | `NSNumber?` | The number the notification should display on the app icon. |
| body | `String!` | The body string of the notification. |
| delivered | `Bool` | The delivery status of the notification. `read-only` |
| identifier<sup>[1]</sup> | `String!` | A string assigned to the notification for later access. |
| scheduled | `Bool` | The status of the notification. `read-only` |
| sound | `RobinNotificationSound` | The sound name of the notification. `not available on watchOS`|
| threadIdentifier | `String?` | The identifier used to visually group notifications together. |
| title | `String?` | The title string of the notification. |
| trigger | `Enum` | The trigger that causes the notification to fire. One of `date` or `location`. |
| userInfo<sup>[2]</sup> | `[AnyHashable : Any]!` | A dictionary that holds additional information. |

[1] `identifier` is read-only after `RobinNotification` is initialized.

[2] To add and remove keys in `userInfo`, use `setUserInfo(value: Any, forKey: AnyHashable)` and `removeUserInfoValue(forKey: AnyHashable)` respectively.

### Schedule a notification

After creating a `RobinNotification` object, it can be scheduled using `schedule(notification: RobinNotification)`.

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

### Schedule a notification group

Robin utilizes the `threadIdentifier` property to manage multiple notifications as a group under the same identifier. To group multiple notifications under the same identifier, you can either set `threadIdentifier` of the notification to the same string or schedule a notification group by calling `schedule(group: RobinNotificationGroup)`:

```swift
let notifications = ... // an array of `RobinNotification`
let group = RobinNotificationGroup(notifications: notifications)
// or
let group = RobinNotificationGroup(notifications: notifications, identifier: "group_identifier")

let scheduledGroup = Robin.scheduler.schedule(group: group)
```

Robin will automatically set `threadIdentifier` of each `RobinNotification` in the array to the group's identifier. *If you omit `identifier` when initializing the group, Robin will create a unique identifier.*

### Retrieve a notification group

Simply retrieve a scheduled notification group by calling `group(withIdentifier: String) -> RobinNotificationGroup?`.

```swift
let scheduledGroup = Robin.scheduler.group(withIdentifier: "group_identifier")
```

*Robin will return a group if there exists at least one notification with `threadIdentifier` the same as the group's identifier. The returned group might contain less notifications than initially scheduled since some of them might have already been delivered by the system.*

### Cancel a notification group

To cancel a notification group, either call `cancel(group: RobinNotificationGroup)` or `cancel(groupWithIdentifier: String)`

```swift
Robin.scheduler.cancel(group: group)
```

```swift
Robin.scheduler.cancel(groupWithIdentifer: group.identifer)
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

`Robin` is preset to allow 60 notifications to be scheduled by the system. The remaining four slots are kept for the app-defined notifications. These free slots are currently not handled by `Robin`; if you use `Robin` to utilize these slots, the notifications will be discarded. To change the maximum allowed, just update `Robin.maximumAllowedNotifications`.

## Author

Ahmed Mohamed, dev@ahmd.pro

## License

Robin is available under the MIT license. See the [LICENSE](https://github.com/ahmdx/Robin/blob/master/LICENSE) file for more info.
