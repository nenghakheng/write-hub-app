import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        // Check if the user is logged in
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

        if isLoggedIn {
            let initialViewController = MainTabBarController()
            window?.rootViewController = UINavigationController(rootViewController: initialViewController)
        } else {
            let authVC = AuthViewController()
            window?.rootViewController = UINavigationController(rootViewController: authVC)
        }
        
        window?.makeKeyAndVisible()

        return true
    }
}
