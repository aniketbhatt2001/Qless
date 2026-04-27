import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    print("🔗 AppDelegate received URL: \(url.absoluteString)")
    print("🔗 URL scheme: \(url.scheme ?? "none")")
    print("🔗 URL host: \(url.host ?? "none")")
    print("🔗 URL query: \(url.query ?? "none")")
    return super.application(app, open: url, options: options)
  }
}
