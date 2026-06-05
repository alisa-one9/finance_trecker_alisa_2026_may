import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "privacy_channel"
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller : FlutterViewController =
            window?.rootViewController as! FlutterViewController
        let privacyChannel = FlutterMethodChannel(
            name: channelName,
            binaryMessenger: controller.binaryMessenger
        )
        privacyChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: FlutterResult) in
            if call.method == "setScreenshotProtection" {
                if let args =
                    call.arguments as? Dictionary<String, Any>,
                   let enabled = args["enabled"] as? Bool {
                    if enabled {
                        let secureTextField = UITextField()
                        secureTextField.isSecureTextEntry = true

                        self.window?.addSubview(secureTextField)

                        self.window?.layer.superlayer?.addSublayer(
                            secureTextField.layer
                        )

                        secureTextField.layer.sublayers?.first?.addSublayer(
                            self.window!.layer
                        )

                    } else {

                        self.window?.layer.removeAllAnimations()
                    }
                }

                result(true)

            } else {

                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}

