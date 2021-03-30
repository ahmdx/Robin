
[![Platform](https://img.shields.io/cocoapods/p/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Version](https://img.shields.io/cocoapods/v/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Swift 4+](https://img.shields.io/badge/Swift-4.2%2B-orange.svg)](https://swift.org)
[![CI Status](http://img.shields.io/travis/ahmdx/Robin.svg)](https://travis-ci.org/ahmdx/Robin)
[![License](https://img.shields.io/github/license/ahmdx/Robin.svg)](http://cocoapods.org/pods/Robin)
[![Release](https://img.shields.io/github/release/ahmdx/Robin.svg)](https://github.com/ahmdx/Robin/releases/)

Robin is a multi-platform notification interface for iOS, watchOS, and macOS that handles UserNotifications behind the scenes.

```swift
let notification = RobinNotification(body: "Welcome to Robin!", trigger: .interval(5))

_ = Robin.scheduler.schedule(notification: notification)
```

- [Features](#features)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Usage](#usage)
  - [Robin Settings](#robin-settings)
  - [Robin Scheduler](#robin-scheduler)
    - [Schedule a notification](#schedule-a-notification)
    - [Retrieve a scheduled notification](#retrieve-a-scheduled-notification)
    - [Cancel a scheduled notification](#cancel-a-scheduled-notification)
    - [Schedule a notification group](#schedule-a-notification-group)
    - [Retrieve a scheduled notification group](#retrieve-a-scheduled-notification-group)
    - [Cancel a scheduled notification group](#cancel-a-scheduled-notification-group)
  - [Robin Actions](#robin-actions)
  - [Robin Delegate](#robin-delegate)
  - [Robin Manager](#robin-manager)
    - [Retrieve all delivered notifications](#retrieve-all-delivered-notifications)
    - [Remove a delivered notification](#remove-a-delivered-notification)
- [Notes](#notes)
- [Author](#author)
- [License](#license)

# Features

 - [x] Request notification permissions
 - [x] Query notification settings
 - [x] Schedule date, location, and interval notifications
 - [x] Handle notification response actions (including text responses)
 - [x] Manage delivered notifications in the notification center
 - [ ] Push notifications support
 - [x] iOS, watchOS, and macOS support
 - [x] High test coverage
 - [x] Swift Package Manager
 - [x] CocoaPods

# Requirements

- iOS 10.0+
- watchOS 3.0+
- macOS 10.14+
- Xcode 11.1+
- Swift 4.2+

# Communication

- If you need help or have a question, use 'robin' tag on [Stack Overflow](http://stackoverflow.com/questions/tagged/robin).
- If you found a bug or have a feature request, please open an issue.

Please do not open a pull request until a contribution guide is published.

# Installation

Robin is available through both [Swift Package Manager](https://swift.org/package-manager/) and [CocoaPods](http://cocoapods.org).

To install using SPM:

```swift
.package(url: "https://github.com/ahmdx/Robin", from: "0.98.0"),
```

CocoaPods:

```ruby
pod 'Robin', '~> 0.98.0'
```

And if you want to include the test suite in your project:

```ruby
pod 'Robin', '~> 0.98.0', :testspecs => ['Tests']
```

# Usage

```swift
import Robin
```

Robin is divided into multiple sub-modules (discussed below):

- Actions
- Delegate
- Manager
- Scheduler
- Settings

Each sub-module has separate concerns which allows Robin to be modular and easily extended. Each section below, ordered by their entry point, will discuss the different sub-modules.

## Robin Settings

The settings sub-module is concerned with requesting notification permissions and querying the app's available notification settings.

Before using `Robin`, you need to request permission to send notifications to users. The following requests `badge`, `sound`, and `alert` permissions. For all available options, refer to [UNAuthorizationOptions](https://developer.apple.com/documentation/usernotifications/unauthorizationoptions).

```swift
Robin.settings.requestAuthorization(forOptions: [.badge, .sound, .alert]) { grant, error in
  // Handle authorization or error.
}
```

To query for the app's notification settings, you can use `Robin.settings` as follows:

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

## Robin Scheduler

The scheduler sub-module is concerned with scheduling and managing scheduled notifications; rescheduling, canceling, and retrieving notifications.

Scheduling notifications via `Robin` is carried over by manipulating `RobinNotification` objects. To create a `RobinNotification` object, simply call its initializer.

```swift
init(identifier: String = default, body: String, trigger: RobinNotificationTrigger = default)
```

Example notification, with a unique identifier, to be fired an hour from now.

```swift
let notification = RobinNotification(body: "A notification", trigger: .date(.next(hours: 1), repeats: .none))
```

> Note: `next(minutes:)`, `next(hours:)`, `next(days:)`, `next(weeks:)`, `next(months:)`, and `next(years:)` are part of a `Date` extension. Robin supports the following repeating interval `.none`, `.hour`, `.day`, `.week`, and `.month`.

Example notification, with a unique identifier, to be fired 30 seconds from now.

```swift
let notification = RobinNotification(body: "A notification", trigger: .interval(30, repeats: false))
```

> Note: Repeating a notification with an interval of less than 60 seconds might cause the app to crash.

Example notification, with a unique identifier, to be fired when entering a region.

```swift
/// https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger
let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
region.notifyOnEntry = true
region.notifyOnExit = false

let notification = RobinNotification(body: "A notification", trigger: .location(region))
```

> Note: For the system to deliver location notifications, the app should be authorized to use location services, see [here](https://developer.apple.com/documentation/usernotifications/unlocationnotificationtrigger). *Robin does not check whether the required permissions are granted before scheduling a location notification. Location notifications are not available on either macOS or watchOS.*

The following table summarizes all `RobinNotification` properties.

| Property | Type | Description |
| --- | --- | --- |
| badge | `NSNumber?` | The number the notification should display on the app icon. |
| body | `String!` | The body string of the notification. |
| categoryIdentifier | `String?` | The identifier of the notification's category. |
| delivered | `Bool` | The delivery status of the notification. `read-only` |
| identifier<sup>[1]</sup> | `String!` | A string assigned to the notification for later access. |
| scheduled | `Bool` | The status of the notification. `read-only` |
| sound | `RobinNotificationSound` | The sound name of the notification. `not available on watchOS`|
| threadIdentifier | `String?` | The identifier used to visually group notifications together. |
| title | `String?` | The title string of the notification. |
| trigger | `enum` | The trigger that causes the notification to fire. One of `date`, `interval`, or `location`. |
| userInfo<sup>[2]</sup> | `[AnyHashable : Any]!` | A dictionary that holds additional information. |

[1] `identifier` is read-only after `RobinNotification` is initialized.

[2] To add and remove keys in `userInfo`, use `setUserInfo(value: Any, forKey: AnyHashable)` and `removeUserInfoValue(forKey: AnyHashable)` respectively.

### Schedule a notification

After creating a `RobinNotification` object, it can be scheduled using `schedule(notification: RobinNotification)`.

```swift
let scheduledNotification = Robin.scheduler.schedule(notification: notification)
```

Now `scheduledNotification` is a valid `RobinNotification` object if it is successfully scheduled or `nil` otherwise.

### Retrieve a scheduled notification

Simply retrieve a scheduled notification by calling `notification(withIdentifier: String) -> RobinNotification?`.

```swift
let scheduledNotification = Robin.scheduler.notification(withIdentifier: "identifier")
```

### Cancel a scheduled notification

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

### Retrieve a scheduled notification group

Simply retrieve a scheduled notification group by calling `group(withIdentifier: String) -> RobinNotificationGroup?`.

```swift
let scheduledGroup = Robin.scheduler.group(withIdentifier: "group_identifier")
```

*Robin will return a group if there exists at least one notification with `threadIdentifier` the same as the group's identifier. The returned group might contain less notifications than initially scheduled since some of them might have already been delivered by the system.*

### Cancel a scheduled notification group

To cancel a notification group, either call `cancel(group: RobinNotificationGroup)` or `cancel(groupWithIdentifier: String)`

```swift
Robin.scheduler.cancel(group: group)
```

```swift
Robin.scheduler.cancel(groupWithIdentifer: group.identifer)
```

## Robin Actions

Notifications can be scheduled with actions the users can interact with. When a user responds to a notification action, the system then informs the app about the notification and its actions' identifiers to process the user's response. Learn more about setting notification actions and categories [here](https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types).

The actions sub-module is concerned with registering and de-registering action handlers that are invoked when a notification response is delivered by the system. *This sub-module requires the delegate sub-module to function properly.*

If your app uses many different notification actions, it may become cumbersome to handle each action. Robin actions allows you to separate the handling of each notification action type into its own isolated space. To do so, your app will need to create an object for each action type and have it conform to the `RobinActionHandler` protocol:

```swift
struct ExampleActionHandler: RobinActionHandler {
  func handle(response: RobinNotificationResponse) {
    /// Handle the response here.
  }
}
```

> Note: `RobinNotificationResponse` contains two properties, the delivered `notification` and an optional `userText?`. `userText` contains the text the user typed when responding to a `UNTextInputNotificationAction`.

and register the action handler for an action identifier:

```swift
Robin.actions.register(actionHandler: ExampleActionHandler.self, forIdentifier: "<ACTION_IDENTIFIER>")
```

If you would like to deregister any registered action handler, simply call:

```swift
Robin.actions.deregister(actionHandlerForIdentifier: "<ACTION_IDENTIFIER>")
```

If you want to schedule a notification with actions, set its `categoryIdentifier` property:

```swift
notification.categoryIdentifier = "<CATEGORY_IDENTIFIER>"
```

> Note: You need to set the category identifier in the notification center first as shown [here](https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types).

Example from Apple's [documentation](https://developer.apple.com/documentation/usernotifications/declaring_your_actionable_notification_types):

```swift
// Define the custom actions.
let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
      title: "Accept", 
      options: UNNotificationActionOptions(rawValue: 0))
let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
      title: "Decline", 
      options: UNNotificationActionOptions(rawValue: 0))
// Define the notification type
let meetingInviteCategory = 
      UNNotificationCategory(identifier: "MEETING_INVITATION",
      actions: [acceptAction, declineAction], 
      intentIdentifiers: [], 
      hiddenPreviewsBodyPlaceholder: "",
      options: .customDismissAction)
// Register the notification type.
let notificationCenter = UNUserNotificationCenter.current()
notificationCenter.setNotificationCategories([meetingInviteCategory])

// Register action handlers early in the app's lifecycle.
Robin.actions.register(actionHandler: AcceptActionHandler.self, forIdentifier: "ACCEPT_ACTION")
Robin.actions.register(actionHandler: DeclineActionHandler.self, forIdentifier: "DECLINE_ACTION")

// Schedule a notification later on.
let notification = RobinNotification(body: "A notification", trigger: .date(.next(hours: 1), repeats: .none))
notification.categoryIdentifier = "MEETING_INVITATION"

_ = Robin.scheduler.schedule(notification: notification)
```

Robin uses its delegate sub-module to determine which handler to invoke when the system delivers the notification response to the app. You will need to register the action handlers early in the app's lifecycle to not miss handling the responses.

## Robin Delegate

The delegate sub-module is concerned with handling the notification center's delegate methods. Currently, it only supports processing received notification responses.

To correctly invoke registered action handlers, your `UNNotificationCenterDelegate` object will need to inform Robin about the response:

```swift
func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
  Robin.delegate.didReceiveResponse(response, withCompletionHandler: completionHandler)
}
```

> Note: If you don't pass the `completionHandler`, you will need to call it yourself.

When a notification response is received, Robin will invoke the correct action handler if it is already registered.

## Robin Manager

The manager sub-module is concerned with managing delivered notifications in the notification center.
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

# Notes

`Robin` is preset to allow 60 notifications to be scheduled by the system. The remaining four slots are kept for the app-defined notifications. These free slots are currently not handled by `Robin`; if you use `Robin` to utilize these slots, the notifications will be discarded.

# Author

Ahmed Mohamed, dev@ahmd.pro

# License

Robin is available under the MIT license. See the [LICENSE](https://github.com/ahmdx/Robin/blob/master/LICENSE) file for more info.
