//
//  TopNewsTableViewCell.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 17.07.2021.
//

import UIKit

class TopNewsTableViewCell: UITableViewCell {
    
    static let identifier = "TopNewsTableViewCell"
    static var nibName: UINib {
        get {
            return UINib(nibName: identifier, bundle: nil)
        }
    }
    
    @IBOutlet weak var topIconView: UIView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var topNewsCollection: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initUI()
    }
    
// MARK: - Public methods
    
    func setupPageControll(numberOfPages: Int,
                           pageNumber page: Int) {
        
        pageControll.numberOfPages = numberOfPages
        
        setupSelectedPage(pageNumber: page)
    }
    
    func setupSelectedPage(pageNumber page: Int) {
        pageControll.currentPage = page
    }
    
    func setupCollectionView(delegate: UICollectionViewDelegate,
                             dataSource: UICollectionViewDataSource) {
        topNewsCollection.delegate = delegate
        topNewsCollection.dataSource = dataSource
        topNewsCollection.register(TopNewsCollectionViewCell.nibName, forCellWithReuseIdentifier: TopNewsCollectionViewCell.identifier)
    }
    
    
// MARK: - Private methods
    
    private func initUI() {
        topIconView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 5.0)
    }
    
}
