import Foundation

class LikeService {
    private let apiManager = APIManager.shared
    
    func likePost(like: Like, completion: @escaping (Result<Like, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/likes") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "postId": like.postId ?? 0,
            "userId": like.userId ?? 0
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
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
                let createdLike = try JSONDecoder().decode(Like.self, from: data)
                completion(.success(createdLike))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
