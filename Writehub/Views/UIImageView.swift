import UIKit

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }

        // Load the image asynchronously
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    print("Failed to create image from data")
                }
            } catch {
                print("Failed to load image data: \(error.localizedDescription)")
            }
        }
    }
}
