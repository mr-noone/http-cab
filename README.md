# HTTPCab

HTTPCab - network framework for HTTP requests and REST.

## Usage

### Using `Providers` for structure you requests:

```swift
enum ProfileRequests {
  case getUserProfile(id: String)
  case postUserPhoneNumber(phoneNumber: String)
}
```

Then you need to specify all data you need for requests:

```swift
extension ProfileRequests: Request {
  var baseURL: String { 
    return "https://your.domain.com"
  }
  
  var path: String { 
    switch self {
    case .getUserProfile,
         .postUserPhoneNumber:
      return "/user"
    }
  }
  
  var method: Method {
    switch self {
    case .getUserProfile:
      return .get
    case .postUserPhoneNumber:
      return .post
    }
  }
  
  var parameters: [String: String]? { 
    switch self {
    case .getUserProfile(id: let id):
      return ["user_id": id]
    case .postUserPhoneNumber:
      return nil
    }
  }
  
  var body: Any? {
    switch self {
    case .getUserProfile:
      return nil
    case .postUserPhoneNumber(phoneNumber: let phoneNumber):
      return ["phone_number": phoneNumber]
    }
  }
  
  var encoder: BodyEncoder? {
    switch self {
    case .getUserProfile:
      return nil
    case .postUserPhoneNumber:
      return BodyJSONEncoder()
    }
  }
  
  var headers: [String: String]? { 
    return nil
  }
}
```

For usage you need to specify the `Provider` that will handle this requests:

```swift
class YourProfileProvider: Provider {
  func getUser(id: String) {
    dataRequest {
      ProfileRequests.getUserProfile(id: id)
    }.response { data, response, error in {
      //...
    }
  }
  
  func updatePhoneNumber(phone: String) {
    dataRequest {
      ProfileRequests.postUserPhoneNumber(phoneNumber: phoneNumber)
    }.response { data, response, error in {
      //...
    }
  }
}
```

## Encoding

There are 2 main encoding types:

* `BodyJSONEncoder`
* `BodyPlistEncoder`

You can create a custom encoder by implement `BodyEncoder` protocol:

```swift
class CustomEncoder: BodyEncoder {
  func encode(_ body: Any?) -> Data? {
    //...
  }
}
```
