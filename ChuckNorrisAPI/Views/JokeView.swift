//
//  JokeView.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 15/08/22.
//

import Foundation
import UIKit

class JokeView: UIView, ViewConfiguration {
    private enum Constants {
        static let primaryFontSize: CGFloat = 18
        static let secondaryFontSize: CGFloat = 24
        
        static let primaryDarkModeFontColor: UIColor = .white
        static let secondaryDarkModeFontColor: UIColor = .lightGray
        
        static let primaryLightModeFontColor: UIColor = .black
        static let secondaryLightModeFontColor: UIColor = .darkGray
    }
        
    var jokeText: String? = "" {
        didSet {
            jokeLabel.text = jokeText
        }
    }
    
    var iconUrl: String? = "" {
        didSet {
            imageView.setImage(withURL: iconUrl ?? "", placeholderImage: placeholderImage!)
        }
    }
    
    
    let placeholderImage = UIImage.init(named: "chuck-icon@3x.png")

    private var jokeLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: Constants.primaryFontSize, weight: .regular)
        lbl.textColor = Constants.primaryLightModeFontColor
        lbl.text =  "Erro"
        lbl.numberOfLines = 0

        return lbl
    }()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.isAccessibilityElement = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
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
}

extension JokeView {
    internal func setupViews() {
        backgroundColor = .white
    }
    
    internal func setupViewsArrangement() {
        addSubview(jokeLabel)
        addSubview(imageView)
    }
    
    internal func setupConstraints() {
        let margins = layoutMarginsGuide

        jokeLabel.anchor(top: margins.topAnchor, paddingTop: 215)
        jokeLabel.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 36, paddingRight: 36)
        
        imageView.anchor(top: jokeLabel.bottomAnchor, paddingTop: 85)
        imageView.anchor(width: 50, height: 50)
        imageView.anchor(horizontal: margins.centerXAnchor)
    }
    
}
