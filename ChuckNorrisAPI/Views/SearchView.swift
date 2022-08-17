//
//  SearchView.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 16/08/22.
//

import Foundation
import UIKit

class SearchView: UIView, ViewConfiguration, UITableViewDelegate, UITableViewDataSource {
    
    private enum Constants {
        static let primaryFontSize: CGFloat = 18
        static let secondaryFontSize: CGFloat = 25
        
        static let primaryDarkModeFontColor: UIColor = .white
        static let secondaryDarkModeFontColor: UIColor = .lightGray
        
        static let primaryLightModeFontColor: UIColor = .black
        static let secondaryLightModeFontColor: UIColor = .darkGray
    }
    
    var viewModel: SearchViewModel?

    var searchNavigationDelegate: SearchNavigationDelegate?
    
    private var items: [Joke]?

    private var searchLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: Constants.secondaryFontSize, weight: .regular)
        lbl.textColor = Constants.primaryLightModeFontColor
        lbl.text =  "Buscar piadas"
        lbl.numberOfLines = 0

        return lbl
    }()
    
    let searchFieldViewContainer = UIView()
    
    private var searchFieldStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.contentMode = .scaleToFill
        
        return stackView
    }()
    
    private var searchIconView: UIImageView = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "search icon.png")
        imageView.image = image
        imageView.isAccessibilityElement = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    private var searchField: UITextField = {
       var txtField = UITextField()
        txtField.placeholder = "Buscar por palavra"
        txtField.borderStyle = .none
        txtField.textColor = .systemBlue
        txtField.addTarget(self, action: #selector(stoppedWriting(textField:)), for: .editingDidEndOnExit)

        return txtField
    }()
    
    private var searchCancelButtonView: UIButton = {
        let button = UIButton(type: .custom)
        
        let image = UIImage(named: "close@3x.png")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapCancelSearch), for: .touchUpInside)

        return button
    }()
    
    let viewContainer = UIView()

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "Mask Group 2@3x.png")
        imageView.image = image
        imageView.isAccessibilityElement = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    
    let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false

        return table
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
    
    private func loadJokes() {
        let margins = layoutMarginsGuide
                
        activityIndicator.stopAnimating()
                
        tableView.isHidden = false

        searchLabel.removeAllConstraints()
        searchLabel.anchor(top: self.layoutMarginsGuide.topAnchor, paddingTop: 10)
        searchLabel.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 96, paddingRight: 96)

        searchFieldViewContainer.anchor(top: searchLabel.bottomAnchor, paddingTop: 43)


        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func stoppedWriting(textField: UITextField) {
        if let query = searchField.text, searchField.text != "" {
            searchField.isEnabled = false
            
            searchField.resignFirstResponder()
            imageView.isHidden = true
            activityIndicator.startAnimating()

            viewModel?.fetchJokes(query: query) { [weak self] (result) in
                DispatchQueue.main.async { [weak self] in
                    switch result {
                    case .success:
                        self?.loadJokes()
                        self?.setupTable()
                        self?.searchField.isEnabled = true

                    case .failure(let error):
                        print(error)
                        self?.searchField.isEnabled = true
                    }
                }
            }
        }
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = viewContainer.bounds
        tableView.reloadData()
        
        viewContainer.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let totalJokes = viewModel?.model?.total {
            return totalJokes
        }
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 3;

        if let joke = viewModel?.model?.result[indexPath.row].value {
            cell.textLabel?.attributedText = formatSearchedText(initialText: joke)
        } else {
            cell.textLabel?.text = "Erro"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let joke = viewModel?.model?.result[indexPath.row] {
            searchNavigationDelegate?.showJokeVC(joke: joke)
        }
    }
    
    func formatSearchedText(initialText: String) -> NSMutableAttributedString {

        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: initialText)

        let range: NSRange = (initialText as NSString)
            .range(of: searchField.text ?? "Chuck", options: .caseInsensitive)


        attrString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)

        return attrString
    }
    
    func resetView() {
        let margins = layoutMarginsGuide
                                
        searchLabel.removeAllConstraints()

        searchLabel.anchor(top: margins.topAnchor, paddingTop: 158)
        searchLabel.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 96, paddingRight: 96)

        searchFieldViewContainer.anchor(top: searchLabel.bottomAnchor, paddingTop: 43)
        
        viewContainer.removeAllConstraints()
        
        viewContainer.anchor(top: searchFieldViewContainer.bottomAnchor, bottom: margins.bottomAnchor, paddingTop: 30, paddingBottom: 30)
        viewContainer.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        imageView.anchor(bottom: viewContainer.bottomAnchor, paddingBottom: 98)
        imageView.anchor(width: 150, height: 150)
        imageView.anchor(horizontal: viewContainer.centerXAnchor)
        
        activityIndicator.anchor(horizontal: viewContainer.centerXAnchor, vertical: viewContainer.centerYAnchor, paddingHorizontal: 0, paddingVertical: 0)
        
        viewModel?.model = nil
        
        tableView.isHidden = true
        
        imageView.isHidden = false
        
        searchField.text = ""

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func didTapCancelSearch() {
        resetView()
    }
}

extension SearchView {
    internal func setupViews() {
        backgroundColor = .white
        
        searchFieldViewContainer.layer.borderWidth = 3
        searchFieldViewContainer.layer.borderColor = UIColor.systemBlue.cgColor
        searchFieldViewContainer.layer.cornerRadius = 5
        searchFieldViewContainer.layer.masksToBounds = true
    }
    
    internal func setupViewsArrangement() {
        addSubview(searchLabel)
        addSubview(searchFieldViewContainer)
        searchFieldViewContainer.addSubview(searchFieldStackView)
        searchFieldStackView.addArrangedSubViews([
            searchIconView,
            searchField,
            (searchCancelButtonView)
        ])
        addSubview(viewContainer)
        viewContainer.addSubview(imageView)
        viewContainer.addSubview(activityIndicator)
    }
    
    internal func setupConstraints() {
        let margins = layoutMarginsGuide

        searchLabel.anchor(top: margins.topAnchor, paddingTop: 158)
        searchLabel.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 96, paddingRight: 96)
        
        searchFieldViewContainer.anchor(top: searchLabel.bottomAnchor, paddingTop: 43)
        searchFieldViewContainer.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 40, paddingRight: 40)
        searchFieldViewContainer.anchor(height: 56)
        
        searchFieldStackView.anchor(left: searchFieldViewContainer.leftAnchor, right: searchFieldViewContainer.rightAnchor, paddingLeft: 10, paddingRight: 10)
        searchFieldStackView.anchor(top: searchFieldViewContainer.topAnchor, bottom: searchFieldViewContainer.bottomAnchor, paddingTop: 10, paddingBottom: 10)

        viewContainer.anchor(top: searchFieldViewContainer.bottomAnchor, bottom: margins.bottomAnchor, paddingTop: 30, paddingBottom: 30)
        viewContainer.anchor(left: margins.leftAnchor, right: margins.rightAnchor, paddingLeft: 30, paddingRight: 30)
        
        imageView.anchor(bottom: viewContainer.bottomAnchor, paddingBottom: 98)
        imageView.anchor(width: 150, height: 150)
        imageView.anchor(horizontal: viewContainer.centerXAnchor)
        
        activityIndicator.anchor(horizontal: viewContainer.centerXAnchor, vertical: viewContainer.centerYAnchor, paddingHorizontal: 0, paddingVertical: 0)
    }
    
}

extension UIStackView {
    func addArrangedSubViews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
