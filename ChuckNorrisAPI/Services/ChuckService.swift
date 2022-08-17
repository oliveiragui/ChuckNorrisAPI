//
//  ChuckService.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 15/08/22.
//

import Foundation

struct ChuckService {
    
    func fetchJokes(url: String, completion: @escaping (Result<QueryResponse, Error>) -> Void) {
        URLSession.shared.request(url: URL(string: url), expecting: QueryResponse.self) { (result) in
            completion(result)
        }
    }
    
    func fetchRandomJoke(url: String, completion: @escaping (Result<Joke, Error>) -> Void) {
        URLSession.shared.request(url: URL(string: url), expecting: Joke.self) { (result) in
            completion(result)
        }
    }
}
