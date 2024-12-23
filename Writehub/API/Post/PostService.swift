import Foundation

class PostService {
    private let apiManager = APIManager.shared
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/posts") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        let task = apiManager.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            do {
                let postResponse = try JSONDecoder().decode(PostResponse.self, from: data)
                if let posts = postResponse.data?.posts {
                    completion(.success(posts))
                } else {
                    completion(.failure(NetworkError.unknown))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func createPost(post: Post, imageData: Data, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/posts") else {
            completion(.failure(NetworkError.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        // Append userId to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(post.userId ?? 0)\r\n".data(using: .utf8)!)

        // Append caption to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"caption\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(post.caption ?? "")\r\n".data(using: .utf8)!)

        // Append image to the body
        let filename = "image.jpg"
        let mimetype = "image/jpeg"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // Close the body with the boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        print("creatingnnngngngngnggngn post")
        print(request.httpBody)

        let task = apiManager.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }

            do {
                let createdPost = try JSONDecoder().decode(Post.self, from: data)
                
                print("creatingnnngngngngnggngn post")
                print(createdPost)
                
                completion(.success(createdPost))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
