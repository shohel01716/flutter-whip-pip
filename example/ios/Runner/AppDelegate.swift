import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    lazy var flutterEngine = FlutterEngine(name: "FlutterEngine")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run();
        
        let controller =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        let nativeCallChannel = FlutterMethodChannel(name: "rana_channel",binaryMessenger: controller.binaryMessenger)
        
        nativeCallChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping  FlutterResult)  -> Void in
            switch (call.method) {
            case "createPiP":
                let arguments = call.arguments as? [String: Any] ?? [String: Any]()
                let remoteStreamId = arguments["remoteStreamId"] as? String ?? ""
                let peerConnectionId = arguments["peerConnectionId"] as? String ?? ""
                let isRemoteCameraEnable = arguments["isRemoteCameraEnable"] as? Bool ?? false
                let myAvatar = arguments["myAvatar"] as? String ?? ""
               
                
                RanaViewController.shared.configurationPictureInPicture(result: result, peerConnectionId: peerConnectionId, remoteStreamId: remoteStreamId, isRemoteCameraEnable: isRemoteCameraEnable, myAvatar: myAvatar)
                
                break
            case "disposePiP":
                RanaViewController.shared.disposePictureInPicture()
                result(true)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        })
        
        
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
