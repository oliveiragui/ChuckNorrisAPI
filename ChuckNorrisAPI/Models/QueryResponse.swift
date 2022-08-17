//
//  QueryResponse.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 15/08/22.
//

import Foundation

struct QueryResponse: Codable {
    var total: Int
    var result: [Joke]
    
    enum CodingKeys: String, CodingKey {
        case total
        case result
    }
}
