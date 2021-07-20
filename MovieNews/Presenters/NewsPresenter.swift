//
//  NewsPresenter.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 15.07.2021.
//

import Foundation

class NewsPresenter {
    
    weak private var delegate: NewsListDelegate?
    
    private(set) var mostPopular: News?
    private(set) var topRated: News?
    
    /**
     Indicates number of the last loaded page
     Used for loading new pages when user scroll down
     */
    private var loadedPageNumber = 1
    
// MARK: - Public methods
    
    func setViewDelegate(viewDelegate delegate: NewsListDelegate){
        self.delegate = delegate
    }
    
    func loadNews() {
        loadTopRated(page: 1)
        loadMostPopular(page: loadedPageNumber)
    }
    
    func loadMoreNews() {
        loadedPageNumber += 1
        loadNews()
    }
    
    func resetNewsData() {
        mostPopular = nil
        topRated = nil
        delegate?.reloadData()
    }
    
        
// MARK: - Private methods
    
    private func loadTopRated(page: Int) {
        loadData(urlString: "\(NetworkService.shared.topRatedStringRequest)\(page)") {
            [weak self] data in
            
            self?.topRated = data
            self?.delegate?.reloadData()
        }
    }
    
    private func loadMostPopular(page: Int) {
        
        loadData(urlString: "\(NetworkService.shared.mostPopularStringRequest)\(page)") { [weak self] data in
            
            if self?.mostPopular == nil {
                self?.mostPopular = data
            } else {
                self?.mostPopular?.articles.append(contentsOf: data.articles)
            }
            self?.delegate?.reloadData()
        }
        
    }
    
    private func loadData(urlString: String, onSuccess: @escaping ((News) -> Void) ) {
        
        guard let url = URL(string: urlString) else { return }
        NetworkService.shared.loadData(from: url, dataModel: News.self) { data in
            onSuccess(data)
        }
        
    }
    
    
}
