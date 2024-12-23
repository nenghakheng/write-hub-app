import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)

        let createPostVC = UINavigationController(rootViewController: CreatePostViewController())
        createPostVC.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "plus.square.fill"), tag: 1)

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle.fill"), tag: 2)

        viewControllers = [homeVC, createPostVC, profileVC]
    }
}
