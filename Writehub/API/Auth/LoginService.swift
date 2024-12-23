import Foundation

class LoginService {
    private let apiManager = APIManager.shared
    
    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/auth/login") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
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
                // Decode the JSON response
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                // Save the token in UserDefaults
                UserDefaults.standard.set(loginResponse.token, forKey: "authToken")
                
                // Pass the user data to the completion handler
                completion(.success(loginResponse.data.user))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// Define the structures for decoding the response
struct LoginResponse: Codable {
    let status: String
    let token: String
    let data: UserData
}

struct UserData: Codable {
    let user: User
}
