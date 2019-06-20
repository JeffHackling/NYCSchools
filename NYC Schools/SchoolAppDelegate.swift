import UIKit

@UIApplicationMain
final class SchoolAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = window ?? UIWindow(frame: UIScreen.main.bounds)
        
        // do work depending on global debug status
        let debug = GlobalDebugConstants.ENABLED
        
        // inject default service & launch application
        let service: SchoolService = (debug == false) ? NetworkSchoolService() : ProxySchoolService()
        let vc = SchoolViewController(service: service)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        // present a DEBUG sign for the user, if needed
        showDebugAlertIfNeeded(debug)
        
        return true
    }
    
    private func showDebugAlertIfNeeded(_ debug: Bool) {
        guard debug == true, let window = window else { return }
        let width: CGFloat = 100.0
        let height: CGFloat = 50.0
        let size = window.frame.size
        let debugView = UILabel(frame: CGRect(x: size.width - width,
                                              y: size.height - height,
                                              width: width,
                                              height: height))
        debugView.textAlignment = .center
        debugView.text = GlobalDebugConstants.message
        debugView.textColor = GlobalDebugConstants.color
        debugView.font = UIFont.boldSystemFont(ofSize: 17.0)
        window.addSubview(debugView)
    }
}
