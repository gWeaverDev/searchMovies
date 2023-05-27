//
//  MainVC.swift
//  MoviesInCollection
//
//  Created by George Weaver on 26.05.2023.
//

import UIKit

class MainVC: UIViewController {
    
    enum Constants {
        static var cellWidth: CGFloat = 300
        static var cellHeight: CGFloat = 450
        static var cellSpacing: CGFloat = 25
        static var rightSideOffset: CGFloat = 25
    }
    
    var dataModel: [MovieDocs] = []
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.decelerationRate = .fast
        collection.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        return collection
    }()
    
    private var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
        layout.minimumLineSpacing = Constants.cellSpacing
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupNavBar()
        setupCollection()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAPIAndHandleData()
    }
    
    private func setupAppearance() {
        view.backgroundColor = .black
        view.layoutMargins.left = 10
        title = "Кинопоиск"
    }
    
    private func setupNavBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        
        navBar.prefersLargeTitles = true
        navBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor.systemOrange]
    }
    
    private func setupCollection() {
        flowLayout.sectionInset.left = view.layoutMargins.left
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupLayout() {
        view.addSubviewWithoutAutoresizing(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchAPIAndHandleData() {
        ApiManager.shared.getMovies { [weak self] movies in
            self?.dataModel = movies.docs
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

}

extension MainVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCell.reuseIdentifier,
            for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        
        cell.fill(from: dataModel[indexPath.row])
        
        return cell
    }
    
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pointeeX = targetContentOffset.pointee.x
        let pageIndex = round(pointeeX / (Constants.cellWidth + Constants.cellSpacing))
        let newOffset = pageIndex * (Constants.cellWidth + Constants.cellSpacing) - Constants.rightSideOffset
        targetContentOffset.pointee.x = newOffset
    }
}

