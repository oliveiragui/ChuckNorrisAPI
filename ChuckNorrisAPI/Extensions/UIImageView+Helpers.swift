//
//  UIImageView.swift
//  ChuckNorrisAPI
//
//  Created by Guiherme de Oliveira Macedo on 16/08/22.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(withURL urlString: String, placeholderImage: UIImage) {
        image = placeholderImage
        
        let url = URL.init(string: urlString)
        let request = URLRequest.init(url: url!)
        let session = URLSession.shared

        let datatask = session.dataTask(with: request) { (data, response, error) in
            if let imgData = data {
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage.init(data: imgData)
                }
            }
            
        }
        datatask.resume()
    }
}
