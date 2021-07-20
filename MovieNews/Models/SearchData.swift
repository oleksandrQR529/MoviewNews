//
//  SearchData.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 17.07.2021.
//

import Foundation

// MARK: - Data

struct SearchData: Codable {
    
    let page: Int
    let details: [SearchDetails]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case details = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}

// MARK: - Result

struct SearchDetails: Codable {
    
    let id: Int
    let logoPath: String?
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
    }
    
}
