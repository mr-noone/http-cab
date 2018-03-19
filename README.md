# HTTPCab

HTTPCab - network framework for HTTP requests and REST.

## Getting started

## Usage

###   Requests


### For simple http requests you can use:

```swift
HTTPCab.request(url, method: .post, parameters: ["key1": "value1", "key2": "value2"], headers: ["headerField": "headerValue"], parametersEncoding: JSONEncoding.default) { (status) in
  switch status {
  case .success(value: let result):
    // Do what you need here
  case .failure(error: let error):
    // Handle error here
  }
}
```

This will use `NetworkManager` class for requests. For customizing requests configuration, you can pass custom `URLSessionConfiguration` object, by default uses URLSessionConfiguration.default:

```swift
let configuration = URLSessionConfiguration.default
configuration.timeoutIntervalForRequest = 15.0
let networkManager = NetworkManager(urlSessionConfiguration: configuration)
networkManager.request(...)
```



### Using `Providers` for structure you requests:

```swift
enum YourProfileRequests {
  case getUserProfile
  case postUserPhoneNumber(phoneNumber: String)
  // ...
}
```


Then you need to specify all data you need for requests:

```swift
extension YourProfileRequests: ProviderConfiguration {
  var baseURL: URL {
    return URL(string: "https://yourBaseUrl.com/")
  }

  var path: String {
    switch self {
    case .getUserProfile:
      return "userProfile"
    case .postUserPhoneNumber(phoneNumber: _):
      return "userPhoneNumber"
    }
  }

  var method: HTTPCab.Method {
    switch self {
    case .getUserProfile:
      return .get
    case .postUserPhoneNumber:
      return .post
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .getUserProfile:
      return ["headerField": "headerValue"]
    default:
      return ["commonHeaderField": "commonHeaderValue"]
    }
  }

  var taskType: TaskType {
    switch self {
    case .getUserProfile:
      return .plainRequest
    case .postUserPhoneNumber(phoneNumber: let phoneNumber):
      return .requestWithParameters(params: ["phone_number": phoneNumber], encoding: JSONEncoding.default)
    }
  }
}
```


For usage you need to specify the `Provider` that will handle this requests and use `configurator` property for making the request:


```swift
class YourProfileRequestsProvider: Provider {
  typealias RequestsType = YourProfileRequests

  func getUserProfile() -> UserProfile {
    configurator.request(.getUserProfile) { (responseStatus) in
      switch responseStatus {
      case .success(value: let value):
        // Handle success here
      case .failure(error: let error):
        // Handle error here
      }
    }
  }

  func postUserPhoneNumber(_ phoneNumber: String) {
    configurator.request(.postUserPhoneNumber(phoneNumber: phoneNumber)) { (responseStatus) in
      switch responseStatus {
      case .success(value: let value):
        // Handle success here
      case .failure(error: let error):
       // Handle error here
      }
    }
  }
}
```


Or you can use abstract `RequestConfigurator` type's object:


```swift
let yourProfileRequestsConfigurator = RequestConfigurator<YourProfileRequests>()

yourProfileRequestsConfigurator.request(.getUserProfile) { (responseStatus) in
  // Handle results here
}
```

`RequestConfigurator` uses `NetworkManager` for making requests, by default `NetworkManager.default`. But you can change it using initializer:
```swift
let configurator = RequestConfigurator<YourProfileRequests>(networkManager: customNetworkManager)
```


## Encoding

There are 3 main encoding types: `JSONEncoding`, `URLEncoding`, `PlistEncoding`.
Access:

```swift
let urlEncoding = URLEncoding.default
let jsonEncoding = JSONEncoding.default

// Different modes for PlistEncoding
let xmlPlistEncoding = PlistEncoding.xmlFormat
let binaryFormat = PlistEncoding.binaryFormat
let openStepFormat = PlistEncoding.openStepFormat
```


Also you can encode data manually and pass it to request. For example:

```swift
// - Array
let arrayParams = ["someValue1", "someValue2", "someValue3"]
let arrayParamsJsonEncoded = arrayParams.jsonEncoded()
let arrayParamsXmlEncoded = arrayParams.plistEncodedWithPlistFormat(.xml) // or .binary, .openSter

// - Dictionary
let dictParams: [String: Any] = ["someKey1": "someValue1", "someKey2": 792]
let dictFormUrlEncoded = dictParams.formUrlEncoded()
let dictParamsJsonEncoded = dictParams.jsonEncoded()
let dictParamsXmlEncoded.plistEncodedWithPlistFormat(.xml) // or .binary, .openSter
```
All of this methods returns `Data?` which you can easily pass to the request as request body parameter. (For example `.requestWithData(:)`)


## RequestResult

Request return an object of type `RequestResult` in success block, which has some useful functional.

```swift
//...
  func getUserProfile() -> UserProfile {
    configurator.request(.getUserProfile) { (responseStatus) in
      switch responseStatus {
      case .success(value: let value):
        // Value - object of type RequestResult
      case .failure(error: let error):
        // Handle error here
      }
    }
  }
 // ...
```

You can easily transform `RequestResult` to JSON using `toJSON()` instance method:

```swift
case .success(value: let value):
  do {
    let json = try value.toJSON()
  } catch {
    //Handle JSON serialization error
  }
```

Or you can easily transfrom `RequestResult` to your model object, that comforms to `Decodable` protocol, using `decodeJSONObject(:)` instance method:

```swift
struct SomeModel: Decodable {
  //Struct stuff here
}
...
case .success(value: let value):
  do {
    let someModelInstance = value.decodeJSONObject(SomeModel.self) //Returns the object of type SomeModel 
  } catch {
    //Handle JSON serialization error
  }
```
