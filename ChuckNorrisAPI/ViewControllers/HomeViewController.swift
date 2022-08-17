//
//  HomeViewController.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 14/08/22.
//

import UIKit


class HomeViewController: UIViewController {
        
    private let viewModel: HomeViewModel = HomeViewModel(service: ChuckService())
    
    private let homeView: HomeView = {
        let view = HomeView()
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        homeView.viewModel = self.viewModel
        homeView.homeNavigationDelegate = self
        
        self.view = homeView
    }
}

extension HomeViewController: HomeNavigationDelegate {
    func showRandomJokeVC(joke: Joke) {
        let jokeVC = JokeViewController(jokeString: joke.value, iconUrl: joke.iconUrl, delegate: nil)
        self.navigationController?.pushViewController(jokeVC, animated: true)
    }
    
    func showSearchJokeVC() {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    
}
