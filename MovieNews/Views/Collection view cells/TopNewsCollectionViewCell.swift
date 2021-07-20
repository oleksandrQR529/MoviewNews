//
//  TopNewsCollectionViewCell.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 17.07.2021.
//

import UIKit

class TopNewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TopNewsCollectionViewCell"
    static var nibName: UINib {
        get {
            return UINib(nibName: identifier, bundle: nil)
        }
    }
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    func updateCell(imageUrl: String,
                    description: String?,
                    source: String?,
                    time: String?) {
        
        cellImage.loadImage(from: imageUrl)
        descriptionLabel.text = description
        sourceLabel.text = source
        
        guard let time = time else { return }
        timeLabel.text = " - \(time)"
    }
    
    override func prepareForReuse() {
        cellImage.image = nil
    }

}
