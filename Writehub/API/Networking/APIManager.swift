import Foundation

class APIManager {
    static let shared = APIManager()
    
    let baseURL = "http://localhost:3000/api/v1"
    let session = URLSession.shared
    
    private init() {}
}
