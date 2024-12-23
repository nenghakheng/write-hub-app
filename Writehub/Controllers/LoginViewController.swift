import UIKit

class LoginViewController: UIViewController {

    var onSwitchToSignup: (() -> Void)?

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let switchToSignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupActions()
    }

    private func setupLayout() {
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, switchToSignupButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        switchToSignupButton.addTarget(self, action: #selector(switchToSignupButtonTapped), for: .touchUpInside)
    }

    private let loginService = LoginService()

    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showLoginFailedAlert(message: "Email or Password is empty")
            return
        }

        loginService.loginUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    guard let userId = user.id else {
                        self?.showLoginFailedAlert(message: "Login failed: User ID is nil")
                        return
                    }
                    
                    // Save login state in UserDefaults
                    UserDefaults.standard.set(userId, forKey: "loggedInUserId")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                    // Replace the root view controller with MainTabBarController
                       if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first {
                           let mainTabBarController = MainTabBarController()
                           window.rootViewController = mainTabBarController
                           UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
                       }
                case .failure(let error):
                    self?.showLoginFailedAlert(message: "Login failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showLoginFailedAlert(message: String) {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc private func switchToSignupButtonTapped() {
        onSwitchToSignup?()
    }
}
