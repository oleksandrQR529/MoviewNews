//
//  SearchResultTableViewCell.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 19.07.2021.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    static var nibName: UINib {
        get {
            return UINib(nibName: identifier, bundle: nil)
        }
    }

    @IBOutlet weak var label: UILabel!
    
}
