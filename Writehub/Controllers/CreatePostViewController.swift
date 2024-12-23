import UIKit
import SnapKit

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    private let captionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write a caption..."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    private let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()

    private var selectedImageData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "New Post"

        setupLayout()

        selectImageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(submitPostTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(captionTextField)
        contentView.addSubview(selectImageButton)
        contentView.addSubview(submitButton)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(imageView.snp.width).multipliedBy(0.75)
        }

        captionTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(imageView)
            make.height.equalTo(40)
        }

        selectImageButton.snp.makeConstraints { make in
            make.top.equalTo(captionTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(selectImageButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(imageView)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-20)
        }
    }

    @objc private func selectImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc private func submitPostTapped() {
        guard let caption = captionTextField.text, !caption.isEmpty,
              let imageData = selectedImageData else {
            print("Caption or image is missing")
            return
        }
        
        guard let userIdString = UserDefaults.standard.string(forKey: "loggedInUserId"),
              let userId = Int(userIdString) else {
            print("No valid user ID found.")
            return
        }

        let post = Post(id: nil, userId: userId, imageUrl: nil, caption: caption, createdAt: nil, updatedAt: nil, user: nil, like: nil, comment: nil)

        let postService = PostService()
        postService.createPost(post: post, imageData: imageData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showSuccessMessage()
                case .failure(let error):
                    print("Failed to create post: \(error.localizedDescription)")
                }
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = selectedImage
            imageView.contentMode = .scaleAspectFill
            selectedImageData = selectedImage.jpegData(compressionQuality: 0.8)
        }
        dismiss(animated: true, completion: nil)
    }

    private func showSuccessMessage() {
        let alert = UIAlertController(title: "Success", message: "Your post was successfully created!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
