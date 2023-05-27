//
//  UiView+Layout.swift
//  MoviesInCollection
//
//  Created by George Weaver on 26.05.2023.
//

import UIKit

extension UIView {
    
    func addSubviewWithoutAutoresizing(_ subviews: UIView...) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
