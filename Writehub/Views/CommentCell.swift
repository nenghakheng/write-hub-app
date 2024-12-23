import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with comment: Comment) {
        contentLabel.text = comment.content
        // Assuming you have a way to fetch and display the user's name
        userNameLabel.text = "User \(comment.content)"  // Replace with actual username
    }
}
