//
//  SearchViewController.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 14/08/22.
//

import UIKit


class SearchViewController: UIViewController {

        
    private let viewModel = SearchViewModel(service: ChuckService())
    
    private let searchView: SearchView = {
        let view = SearchView()
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
        setupNavBar()
    }
    
    func setupView() {
        searchView.viewModel = self.viewModel
        searchView.searchNavigationDelegate = self
    
        self.view = searchView
    }
    
    func setupNavBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "arrow_header_back@3x.png"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func didTapBackButton(sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: SearchNavigationDelegate {
    func showJokeVC(joke: Joke) {
        let jokeVC = JokeViewController(jokeString: joke.value, iconUrl: joke.iconUrl, delegate: self)
        self.navigationController?.pushViewController(jokeVC, animated: true)
    }
}

extension SearchViewController: JokeViewControllerDelegate {
    func resetSearchState() {
        self.searchView.resetView()
    }
}
