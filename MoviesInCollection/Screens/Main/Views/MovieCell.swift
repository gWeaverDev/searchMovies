//
//  MovieCell.swift
//  MoviesInCollection
//
//  Created by George Weaver on 26.05.2023.
//

import Foundation
import UIKit

final class MovieCell: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    private let posterImage: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFill
        poster.layer.cornerRadius = 20
        poster.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        poster.clipsToBounds = true
        return poster
    }()
    
    private let movieTitle: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont(name: "Futura-Bold", size: 16)
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(from model: MovieDocs) {
        ApiManager.shared.loadImage(from: model.poster?.previewUrl) { [weak self] poster in
            guard let self = self else { return }
            self.posterImage.image = poster
        }
        
        movieTitle.text = model.name
    }
    
    private func setupAppearance() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
    }
    
    private func setupLayout() {
        contentView.addSubviewWithoutAutoresizing(posterImage, movieTitle)
        
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImage.heightAnchor.constraint(equalToConstant: 350),
            
            movieTitle.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 10),
            movieTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
