![Sms77.io Logo](https://www.sms77.io/wp-content/uploads/2019/07/sms77-Logo-400x79.png "Sms77.io Logo")

# Official Swift Client for the Sms77.io SMS Gateway API

## Installation

**Swift Package Manager**

Package.swift:

```swift
let package = Package(
        dependencies: [
            .package(url: "https://github.com/sms77io/swift-client")
        ]
)
```

### Usage

```swift
import Sms77Client

let apiKey = "MySms77ioApiKey"
// alternatively setting apikey to nil will read SMS77_API_KEY from environment
// let apiKey = nil
let client = try! Sms77Client(apiKey: apiKey)
debugPrint(client.balance())
```

#### Tests

```swift test```

##### Support

Need help? Feel free to send us an <a href='mailto: support@sms77.io'>email</a>.
