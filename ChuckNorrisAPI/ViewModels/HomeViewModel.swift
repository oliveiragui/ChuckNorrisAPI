//
//  HomeViewModel.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 16/08/22.
//

import Foundation

class HomeViewModel {
    
    private var service: ChuckService?

    var model: Joke?

    init(service: ChuckService) {
        self.service = service
    }
}

extension HomeViewModel {
    func fetchRandomJoke(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        if let service = self.service {
            service.fetchRandomJoke(url: Constants.randomJokeUrl) { (result) in
                switch result {
                case .success(let model):
                    self.model = model
                    completion(Result.success(true))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
}
