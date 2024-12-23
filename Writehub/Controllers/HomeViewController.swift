import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        return tableView
    }()

    private var posts: [Post] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"

        setupTableView()
        setupRefreshControl()
        fetchPosts()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
    }

    @objc private func refreshPosts() {
        fetchPosts()
    }
    
    private let postService = PostService()

    private func fetchPosts() {
        postService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let fetchedPosts):
                    self?.posts = fetchedPosts
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch posts: \(error.localizedDescription)")
                    // Optionally, handle the error (e.g., show an alert)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}
