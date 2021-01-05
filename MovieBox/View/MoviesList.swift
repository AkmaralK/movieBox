//
//  MoviesList.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/24/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MoviesList: UICollectionView {
    let layout = UICollectionViewFlowLayout()
    
    func setUp () {
        self.register(MovieCell.self, forCellWithReuseIdentifier: "movieCell")
        
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .clear
        
        
        layout.scrollDirection = .horizontal
        self.collectionViewLayout = layout
        
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 24
            layout.itemSize = CGSize(width: 120, height: 280)
        }
    }
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
}
