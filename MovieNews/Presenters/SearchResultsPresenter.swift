//
//  SearchResultsPresenter.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 19.07.2021.
//

import Foundation

class SearchResultsPresenter {
    
    weak private var delegate: NewsSearchDelegate?
    
    func setViewDelegate(viewDelegate delegate: NewsSearchDelegate){
        self.delegate = delegate
    }
    
    func loadData(request: String) {
        
        let urlString = "\(NetworkService.shared.searchStringRequest)\(request)"
        
        guard let url = URL(string: urlString) else { return }
        
        NetworkService.shared.loadData(from: url, dataModel: SearchData.self) { [weak self] (data) in
            self?.delegate?.reloadData(data: data)
        }
        
    }
    
}
