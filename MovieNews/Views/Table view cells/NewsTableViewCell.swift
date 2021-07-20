//
//  NewsImageTableViewCell.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 17.07.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier = "NewsTableViewCell"
    static var nibName: UINib {
        get {
            return UINib(nibName: identifier, bundle: nil)
        }
    }
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

// MARK: - Public methods
    
    func updateCell(imageUrl: String,
                    description: String?,
                    source: String?,
                    publicationDate: String?) {
        
        cellImage.loadImage(from: imageUrl)
        cellImage.contentMode = .scaleAspectFit
        descriptionLabel.text = description
        sourceLabel.text = source
        
        guard let publicationDate = publicationDate else { return }
        timeLabel.text = " - \(publicationDate)"
        
    }
    
    override func prepareForReuse() {
        cellImage.image = nil
    }
    
}
