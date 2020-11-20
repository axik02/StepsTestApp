//
//  Comment.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation

struct Comment: Codable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}

