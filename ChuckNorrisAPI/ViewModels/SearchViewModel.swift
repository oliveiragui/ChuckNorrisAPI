//
//  SearchViewModel.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 17/08/22.
//

import Foundation

class SearchViewModel {
    
    private var service: ChuckService?

    var model: QueryResponse?

    init(service: ChuckService) {
        self.service = service
    }
    
    func fetchJokes(query: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        if let service = self.service {
            
            let url = "\(Constants.queryJokes)\(query)"

            service.fetchJokes(url: url) { (result) in
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
