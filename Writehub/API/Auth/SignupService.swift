import Foundation

class SignupService {
    private let apiManager = APIManager.shared
    
    func signupUser(user: User, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(apiManager.baseURL)/auth/signup") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "userType": user.userType ?? "",
            "firstName": user.firstName ?? "",
            "lastName": user.lastName ?? "",
            "email": user.email ?? "",
            "password": password,
            "confirmPassword": password
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
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
