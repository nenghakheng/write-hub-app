import UIKit
import SnapKit

class ProfileViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle") // Default image
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Username"
        label.textAlignment = .center
        label.numberOfLines = 1 // Ensure the text is on a single line
        label.lineBreakMode = .byClipping // Prevent truncation with ellipsis
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "User bio goes here"
        label.numberOfLines = 2
        return label
    }()
    
    private let postsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "30\nPosts"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "62\nLikes"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 1, height: UIScreen.main.bounds.width / 3 - 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupNavigationBar()
        loadUserProfile()
    }

    private func setupNavigationBar() {
        // Set the username in the navigation bar
        navigationItem.titleView = usernameLabel
        
        // Add the logout button with an icon to the right side of the navigation bar
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.right.square"),
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        logoutButton.tintColor = .red
        navigationItem.rightBarButtonItem = logoutButton
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(bioLabel)
        contentView.addSubview(postsLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(followButton)
        contentView.addSubview(messageButton)
        contentView.addSubview(collectionView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalToSuperview().priority(.low)
        }

        // Move Profile Image Up by reducing the top offset
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10) // Adjusted top padding
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }

        // Bio Label Constraints
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        // Post, Followers, and Following Labels Constraints
        postsLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.top.equalTo(profileImageView).offset(20)
            make.width.equalTo(80)
        }
        
        likesLabel.snp.makeConstraints { make in
            make.leading.equalTo(postsLabel.snp.trailing).offset(10)
            make.centerY.equalTo(postsLabel)
            make.width.equalTo(80)
        }
        
        // Follow Button Constraints
        followButton.snp.makeConstraints { make in
            make.top.equalTo(postsLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(36)
            make.trailing.equalTo(contentView.snp.centerX).offset(-10)
        }
        
        // Message Button Constraints
        messageButton.snp.makeConstraints { make in
            make.top.equalTo(followButton)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalTo(contentView.snp.centerX).offset(10)
            make.height.equalTo(36)
        }
        
        // Collection View Constraints
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(followButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private let userService = UserService()
    
    private func loadUserProfile() {
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserId") else {
            print("No user logged in.")
            return
        }
        
        userService.fetchUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.usernameLabel.text = user.username
                    self?.postsLabel.text = "\(user.post?.count ?? 0)\nPosts"
                    
                    // Calculate total likes
                    let totalLikes = user.post?.reduce(0) { $0 + ($1.like?.count ?? 0) } ?? 0
                    self?.likesLabel.text = "\(totalLikes)\nLikes"
                    
                    self?.bioLabel.text = user.email
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("Failed to load user profile: \(error)")
                }
            }
        }
    }
    
    @objc private func logoutButtonTapped() {
        // Clear the stored user ID from UserDefaults
        UserDefaults.standard.removeObject(forKey: "loggedInUserId")
        
        // Navigate back to the LoginViewController
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        // Set the LoginViewController as the root view controller
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}

class PostCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
}
