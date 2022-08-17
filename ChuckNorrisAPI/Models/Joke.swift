//
//  Joke.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 15/08/22.
//

import Foundation

struct Joke: Codable {
    var categories: [String]
    var createdAt: String
    var iconUrl: String
    var id: String
    var updatedAt: String
    var url: String
    var value: String
    
    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconUrl = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url
        case value
    }
}
