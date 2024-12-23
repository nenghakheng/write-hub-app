import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Start with LoginViewController
        showLoginScreen()
    }

    private func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.onSwitchToSignup = { [weak self] in
            self?.showSignupScreen()
        }
        
        replaceCurrentScreen(with: loginVC)
    }

    private func showSignupScreen() {
        let signupVC = SignupViewController()
        signupVC.onSwitchToLogin = { [weak self] in
            self?.showLoginScreen()
        }
        replaceCurrentScreen(with: signupVC)
    }
    
    private func replaceCurrentScreen(with viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = viewController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
