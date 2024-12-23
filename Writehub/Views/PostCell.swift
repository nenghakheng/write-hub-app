import UIKit
import SnapKit

class PostCell: UITableViewCell {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        return button
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(captionLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }

        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }

        commentButton.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.leading.equalTo(likeButton.snp.trailing).offset(10)
        }

        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
        }

        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(likesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with post: Post) {
        // Safely unwrap and load the user's profile image
//        if let profileImageUrl = post.user?.profileImageUrl {
//            profileImageView.loadImage(from: profileImageUrl)
//        } else {
            // Set a default circular avatar image
            profileImageView.image = UIImage(systemName: "person.circle")
            profileImageView.tintColor = .lightGray // Optional: Set a tint color if needed
//        }

        usernameLabel.text = post.user?.username ?? "Unknown"
        
        if let imageUrl = post.imageUrl {
            postImageView.loadImage(from: imageUrl) // Using the loadImage method
        } else {
            postImageView.image = UIImage(systemName: "photo") // Default image if URL is nil
            postImageView.tintColor = .lightGray // Optional: Set a tint color if needed
        }

        let likeCount = post.like?.count ?? 0
        likesLabel.text = "\(likeCount) likes"

        // Create an attributed string with the username in bold
        let username = post.user?.username ?? "Unknown"
        let caption = post.caption ?? ""
        
        let attributedText = NSMutableAttributedString(
            string: "\(username) ",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]
        )
        
        attributedText.append(
            NSAttributedString(
                string: caption,
                attributes: [.font: UIFont.systemFont(ofSize: 14)]
            )
        )
        
        captionLabel.attributedText = attributedText
    }

}
