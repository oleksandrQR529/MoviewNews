//
//  UIImage+Extensions.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 15.07.2021.
//

import UIKit

extension UIImageView {
    
    func loadImage(from url: String) {
        
        NetworkService.shared.loadImage(imageUrl: url) { imageData in
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(data: imageData)
            }
        }
    }
    
}
