//
//  Post.swift
//  Writehub
//
//  Created by Nenghak on 24/8/24.
//

import Foundation

struct Post: Codable {
    let id: Int?
    let userId: Int?
    let imageUrl: String?
    let caption: String?
    let createdAt: String?
    let updatedAt: String?
    let user: User?
    let like: [Like]?
    let comment: [Comment]?
}

