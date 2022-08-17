//
//  HomeNavigationDelegate.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 16/08/22.
//

import Foundation

protocol HomeNavigationDelegate {
    func showRandomJokeVC(joke: Joke)
    func showSearchJokeVC()
}
