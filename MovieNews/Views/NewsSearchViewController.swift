//
//  NewsSearchViewController.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 19.07.2021.
//

import UIKit

protocol NewsSearchDelegate: NSObjectProtocol {
    
    func reloadData<T: Codable>(data: T)
    
}

class NewsSearchViewController: UIViewController {
    
    @IBOutlet weak var resultsTableView: UITableView!
    private let searchController = UISearchController()
    
    private let presenter = SearchResultsPresenter()
    
    private var searchResults: SearchData?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
// MARK: - Private methods
    
    private func initUI() {
        
        presenter.setViewDelegate(viewDelegate: self)
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.register(SearchResultTableViewCell.nibName, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesBottomBarWhenPushed = false
    }

}

// MARK: - UISearchBarDelegate

extension NewsSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.presenter.loadData(request: searchText)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = nil
        resultsTableView.reloadData()
    }
    
}

// MARK: - News search Delegate

extension NewsSearchViewController: NewsSearchDelegate {
    
    func reloadData<T>(data: T) where T : Decodable, T : Encodable {
        
        guard let results = data as? SearchData else { return }
        searchResults = results
        
        resultsTableView.reloadData()
    }
    
}

// MARK: - Table view Delegate & Data Source

extension NewsSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.details.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier) as? SearchResultTableViewCell,
              let detail = searchResults?.details[indexPath.row]
        else { return cell }
        
        cell.label.text = detail.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.bounds.height / 10
    }
    
    
}
