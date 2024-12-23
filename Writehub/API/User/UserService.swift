import Foundation

class UserService {
    private let apiManager = APIManager.shared
    
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/users/\(userId)") else {
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
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                completion(.success((userResponse.data?.user)!))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func updateUser(userId: String, user: User, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/users/\(userId)") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let parameters = try JSONEncoder().encode(user)
            request.httpBody = parameters
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = apiManager.session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            // Print the raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw response JSON: \(jsonString)")
            }
            
            do {
                let updatedUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(updatedUser))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
