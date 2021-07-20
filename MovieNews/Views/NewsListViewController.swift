//
//  ViewController.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 15.07.2021.
//

import UIKit
import LXPageControl

protocol NewsListDelegate: NSObjectProtocol {
    
    func reloadData()
    
}

class NewsListViewController: UIViewController {
    
// MARK: - Outlets
    
    @IBOutlet weak var newsTypesStack:   UIStackView!
    @IBOutlet      var newsTypeButtons:  [UIButton]!
    @IBOutlet weak var allNewsTableView: UITableView!
    
// MARK: - Private variables
        
    private var newsTypePageControll = LXPageControl()
    
    private let newsPresenter = NewsPresenter()
        
// MARK: - Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        newsPresenter.loadNews()
    }
    
// MARK: - Private methods
    
    private func initUI() {
        
        newsPresenter.setViewDelegate(viewDelegate: self)
        
        setupTableView()
        setupPageControll()
        
    }
    
    private func setupTableView() {
        
        allNewsTableView.delegate = self
        allNewsTableView.dataSource = self
        
        allNewsTableView.register(NewsTableViewCell.nibName,
                           forCellReuseIdentifier: NewsTableViewCell.identifier)
        allNewsTableView.register(TopNewsTableViewCell.nibName,
                           forCellReuseIdentifier: TopNewsTableViewCell.identifier)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRight.direction = .left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeft.direction = .right
        
        allNewsTableView.addGestureRecognizer(swipeRight)
        allNewsTableView.addGestureRecognizer(swipeLeft)
        
    }
    
    private func setupPageControll() {
        view.layoutSubviews()
        
        let width = view.bounds.size.width
        let height: CGFloat = 3
        let yPosition = newsTypesStack.bounds.origin.y + newsTypesStack.bounds.height - height * 2
        
        newsTypePageControll.frame = CGRect(x: 0.0,
                                            y: yPosition,
                                            width: width,
                                            height: height)
        newsTypePageControll.pages = 3
        newsTypePageControll.elementWidth = width / CGFloat(newsTypePageControll.pages)
        newsTypePageControll.elementHeight = height
        newsTypePageControll.spacing = 0
        newsTypePageControll.activeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        newsTypePageControll.inactiveColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        newsTypePageControll.isUserInteractionEnabled = false
        view.addSubview(newsTypePageControll)
    }
    
    
// MARK: - Actions

    @IBAction func storiesButtonTapped(_ sender: Any) {
        newsPresenter.newsTypeChanged(pageNumber: 0)
        newsTypePageControll.currentPage = 0
    }
    
    @IBAction func videoButtonTapped(_ sender: Any) {
        newsPresenter.newsTypeChanged(pageNumber: 1)
        newsTypePageControll.currentPage = 1
    }
    
    @IBAction func favouritesButtonTapped(_ sender: Any) {
        newsPresenter.newsTypeChanged(pageNumber: 2)
        newsTypePageControll.currentPage = 2
    }
    
    // MARK: - Objc methods

    @objc func swipeRight() {
        newsPresenter.swipeRight { [weak self] pageNumber in
            self?.newsTypePageControll.currentPage = pageNumber
        }
    }
    
    @objc func swipeLeft() {
        newsPresenter.swipeLeft { [weak self] pageNumber in
            self?.newsTypePageControll.currentPage = pageNumber
        }
    }
    
}

// MARK: - Table view Delegate & Data Source

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsPresenter.mostPopular?.articles.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        guard let article = newsPresenter.mostPopular?.articles[indexPath.row] else { return cell }
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TopNewsTableViewCell.identifier) as? TopNewsTableViewCell else { return cell }
            
            cell.setupCollectionView(delegate: self,
                                     dataSource: self)
            cell.setupPageControll(numberOfPages: newsPresenter.topRated?.articles.count ?? 0,
                                   pageNumber: 0)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else { return cell }
            
            cell.updateCell(imageUrl: (article.backdropPath ?? article.posterPath) ?? "",
                            description: article.title,
                            source: article.originalTitle,
                            publicationDate: article.releaseDate)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return view.bounds.height / 3.5
        }
        
        return UITableView.automaticDimension
    }
    
    ///Load more news when user scroll down
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let presentedNewsCount = newsPresenter.mostPopular?.articles.count else { return }
        
        if indexPath.row == presentedNewsCount - 3 {
            newsPresenter.loadMoreNews()
        }
        
    }
    
}

// MARK: - Collection view Delegate & Data Source & Flow Layout

extension NewsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsPresenter.topRated?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopNewsCollectionViewCell.identifier, for: indexPath) as? TopNewsCollectionViewCell,
              let article = newsPresenter.topRated?.articles[indexPath.row]
        else { return cell }
        
        cell.updateCell(imageUrl: (article.backdropPath ?? article.posterPath) ?? "",
                        description: article.title,
                        source: article.originalTitle,
                        time: article.releaseDate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.bounds.size.width,
                          height: view.bounds.height / 3.5)

        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let topNewsCell = allNewsTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TopNewsTableViewCell else { return }
        
        topNewsCell.setupSelectedPage(pageNumber: indexPath.row)
    }
    
}

// MARK: - News list Delegate

extension NewsListViewController: NewsListDelegate {
    
    func reloadData() {
        allNewsTableView.reloadData()
    }
    
}

