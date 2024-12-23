import UIKit
import SnapKit

class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var post: Post?

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        return tableView
    }()

    private var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self

        captionLabel.text = post?.caption
        fetchComments()
    }

    private func setupLayout() {
        view.addSubview(postImageView)
        view.addSubview(captionLabel)
        view.addSubview(commentsTableView)

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }

        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private let commentService = CommentService()

    private func fetchComments() {
        guard let postId = post?.id else { return }
        commentService.fetchComments(postId: postId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self.comments = comments
                    self.commentsTableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch comments:", error)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.configure(with: comment)
        return cell
    }
}
