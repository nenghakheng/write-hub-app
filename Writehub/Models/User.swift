//
//  User.swift
//  Writehub
//
//  Created by Nenghak on 24/8/24.
//

import Foundation

struct User: Codable {
    let id: Int?
    let userType: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let post: [Post]?
    // Computed property for username
    var username: String {
        return "\(firstName ?? "")"
    }
}

