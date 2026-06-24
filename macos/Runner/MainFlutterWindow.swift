import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Taille d'ouverture confortable, centrée à l'écran.
    let desiredSize = NSSize(width: 1280, height: 840)
    self.setContentSize(desiredSize)
    self.minSize = NSSize(width: 960, height: 640)
    self.center()
    let windowFrame = self.frame
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
