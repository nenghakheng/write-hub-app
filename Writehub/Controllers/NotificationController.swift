//import UIKit
//
//class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
//        return tableView
//    }()
//
//    private var notifications: [Notification] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        title = "Notifications"
//
//        setupTableView()
//        fetchNotifications()
//    }
//
//    private func setupTableView() {
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        tableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//
//    private func fetchNotifications() {
//        // Fetch notifications from the server and reload table view
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return notifications.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
//        let notification = notifications[indexPath.row]
//        cell.textLabel?.text = notification.text
//        return cell
//    }
//}
