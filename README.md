![](https://www.seven.io/wp-content/uploads/Logo.svg "seven Logo")

# Official Swift Client for the seven.io SMS Gateway API

## Installation

**Swift Package Manager**

Package.swift:

```swift
let package = Package(
        dependencies: [
            .package(url: "https://github.com/seven-io/swift-client")
        ]
)
```

### Usage

```swift
import SevenClient

let apiKey = "MySevenApiKey"
// alternatively setting apiKey to nil will read SEVEN_API_KEY from environment
// let apiKey = nil
let client = try! SevenClient(apiKey: apiKey)
debugPrint(client.balance())
```

#### Tests

```swift test```

##### Support

Need help? Feel free to [contact us](https://www.seven.io/en/company/contact/).

[![MIT](https://img.shields.io/badge/License-MIT-teal.svg)](LICENSE)
