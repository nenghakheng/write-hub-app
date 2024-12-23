import Foundation

class CommentService {
    private let apiManager = APIManager.shared
    
    func fetchComments(postId: Int, completion: @escaping (Result<[Comment], Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/comments?postId=\(postId)") else {
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
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                completion(.success(comments))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func createComment(comment: Comment, completion: @escaping (Result<Comment, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/comments") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id": comment.id ?? 0,
            "content": comment.content ?? ""
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
                let createdComment = try JSONDecoder().decode(Comment.self, from: data)
                completion(.success(createdComment))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
