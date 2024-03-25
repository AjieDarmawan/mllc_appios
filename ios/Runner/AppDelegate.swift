import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Hide your app’s preview window and ensure the keyboard is dismissed
  override func applicationWillResignActive(_: UIApplication ) {
    window?.rootViewController?.view.endEditing(true)
    self.window?.isHidden = true;
  }

  // ADD THIS CODE HERE
  // override func applicationWillResignActive(
  //   _ application: UIApplication
  // ) {
  //   self.window.isHidden = true;
  // }

  override func applicationDidBecomeActive(
    _ application: UIApplication
  ) {
    self.window.isHidden = false;
  }

}




// import Flutter
// import UIKit

// let CHANNEL = "disable_screenshots"

// class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
//     let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

//     channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
//       if (call.method == "disable") {
//         UIScreen.main.isCapturedDidChange = { [weak self] in
//           if UIScreen.main.isCaptured {
//             UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//           }
//         }
//         result(true)
//       } else {       
//         result(FlutterMethodNotImplemented)
//       }
//     }

//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }