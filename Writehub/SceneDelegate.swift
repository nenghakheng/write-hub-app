import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

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
    }
}

