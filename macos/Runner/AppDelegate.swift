import Cocoa
import FlutterMacOS
import bitsdojo_window_macos

@main
class AppDelegate: FlutterAppDelegate {
  private var isExiting = false
  private var windowCloseObserver: NSObjectProtocol?
  
  @objc override func applicationDidFinishLaunching(_ notification: Notification) {
    cleanupObserver()
    
    windowCloseObserver = NotificationCenter.default.addObserver(
      forName: NSNotification.Name("BitsdojoWindowPrimaryWillClose"),
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.isExiting = true
      strongSelf.cleanupObserver()
      NSApp.terminate(strongSelf)
    }
    
    signal(SIGPIPE, SIG_IGN)
  }

  private func cleanupObserver() {
    if let observer = windowCloseObserver {
      NotificationCenter.default.removeObserver(observer)
      windowCloseObserver = nil
    }
  }

  @objc override func applicationWillTerminate(_ notification: Notification) {
    cleanupObserver()
  }
  
  @objc override func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
    if isExiting {
      return .terminateNow
    }
    if let window = mainFlutterWindow {
      BitsdojoWindowPlugin.closeRequested(window)
      return .terminateCancel
    }
    return .terminateNow
  }
  
  @objc override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  @objc override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}