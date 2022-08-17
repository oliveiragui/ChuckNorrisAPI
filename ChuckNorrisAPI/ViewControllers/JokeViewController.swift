//
//  JokeViewController.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 15/08/22.
//

import UIKit

protocol JokeViewControllerDelegate {
    func resetSearchState()
}

class JokeViewController: UIViewController {

    var vcDelegate: JokeViewControllerDelegate?
    
    private var jokeString: String?
    
    private var iconUrl: String?

    private let jokeView: JokeView = {
        let view = JokeView()
        return view
    }()
    
    init(jokeString: String, iconUrl: String, delegate: JokeViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        self.jokeString = jokeString
        self.iconUrl = iconUrl
        self.vcDelegate = delegate
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
        jokeView.jokeText = self.jokeString
        jokeView.iconUrl = self.iconUrl
    
        self.view = jokeView
    }
    
    func setupNavBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "arrow_header_back@3x.png"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "close@3x.png"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.setTitle("", for: .normal)
        closeButton.setTitleColor(closeButton.tintColor, for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    
    @objc func didTapBackButton(sender: AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCloseButton(sender: AnyObject){
        self.vcDelegate?.resetSearchState()
        self.navigationController?.popViewController(animated: true)
    }
}
