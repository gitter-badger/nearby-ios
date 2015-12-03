#Nearby iOS Application

[![Join the chat at https://gitter.im/Nearby-iBeacon/nearby-ios](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Nearby-iBeacon/nearby-ios?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This is the iOS client application of NearBy. It is able to detect iBeacons and lookup the server for the associated content with that beacon. This app retrieves the webpage that is associated with a beacon and shows the content to the user.

##Usage
###Compilation/Install
You can build and deploy this application to your iPhone using Xcode.

```bash
git clone https://github.com/Nearby-iBeacon/nearby-ios.git
```

###Execution
An iOS device is needed for using this application.


##Dependencies
All the dependencies are included in the project and here is a list of them: (No installation is required)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking.git)
* [Estimote/iOS-Indoor-SDK](https://github.com/Estimote/iOS-Indoor-SDK.git)

##Structure
Standard Xcode project structure.

##[Potential Bugs](https://github.com/Nearby-iBeacon/nearby-ios/issues)
* The estimote API kit does not support iOS 8 therefore the build fails.

##To do
* Dom & Tom

##License
[MIT license](http://opensource.org/licenses/MIT) 
