//
//  HomeView.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 15/08/22.
//

import Foundation
import UIKit

class HomeView: UIView, ViewConfiguration {
    private enum Constants {
        static let primaryFontSize: CGFloat = 18
        static let secondaryFontSize: CGFloat = 24
        
        static let primaryDarkModeFontColor: UIColor = .white
        static let secondaryDarkModeFontColor: UIColor = .lightGray
        
        static let primaryLightModeFontColor: UIColor = .black
        static let secondaryLightModeFontColor: UIColor = .darkGray
    }

    var viewModel: HomeViewModel?
    
    var homeNavigationDelegate: HomeNavigationDelegate?

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "chucknorris_logo_coloured.png")
        imageView.image = image
        imageView.isAccessibilityElement = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private var placeholderText: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: Constants.primaryFontSize, weight: .regular)
        lbl.textColor = Constants.primaryLightModeFontColor
        lbl.text =  """
                    Laboris nisi est eu excepteur labore pariatur sint. Id anim sunt enim nulla est ex Lorem nulla cillum pariatur et ex ipsum sunt commodo eu aute cillum cillum aute.
                    """
        lbl.numberOfLines = 0

        return lbl
    }()
    
    private var shuffleButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let image = UIImage(named: "Shuffle.png")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapShuffleButton), for: .touchUpInside)

        return button
    }()
    
    private var searchButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Buscar uma piada", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)

        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setupViews()
        setupViewsArrangement()
        setupConstraints()
    }
    
    @objc private func didTapShuffleButton() {
        shuffleButton.isEnabled = false
        viewModel?.fetchRandomJoke { [weak self] (result) in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success:
                    if let joke = self?.viewModel?.model {
                        self?.homeNavigationDelegate?.showRandomJokeVC(joke: joke)
                        self?.shuffleButton.isEnabled = true
                    }
                case .failure(let error):
                    self?.shuffleButton.isEnabled = true
                    print(error)
                }
            }
        }
    }
    
    @objc private func didTapSearchButton() {
        self.homeNavigationDelegate?.showSearchJokeVC()
    }
}

extension HomeView {
    internal func setupViews() {
        backgroundColor = .white
    }
    
    internal func setupViewsArrangement() {
        addSubview(imageView)
        addSubview(placeholderText)
        addSubview(shuffleButton)
        addSubview(searchButton)
    }
    
    internal func setupConstraints() {
        let margins = layoutMarginsGuide

        imageView.anchor(top: margins.topAnchor, paddingTop: 10)
        imageView.anchor(width: 174, height: 104)
        imageView.anchor(horizontal: margins.centerXAnchor)
        
        placeholderText.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 36, paddingRight: 36)
        placeholderText.anchor(top: imageView.bottomAnchor, paddingTop: 40)
        
        shuffleButton.anchor(horizontal: margins.centerXAnchor)

        searchButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 40, paddingRight: 40)
        searchButton.anchor(top: shuffleButton.bottomAnchor, bottom: margins.bottomAnchor, paddingTop: 49, paddingBottom: 40)
        searchButton.anchor(height: 56)

    }
    
}
