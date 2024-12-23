import Foundation

extension JSONDecoder {
    static var customDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        // Customize the decoder as needed, e.g., date decoding strategy
        return decoder
    }
}
