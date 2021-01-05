//
//  MovieFavoritesViewController.swift
//  MovieBox
//
//  Created by Бейбарыс Шагай on 12/27/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MovieFavoritesViewController: UIViewController {
    private let collectionViewSectionInset: CGFloat = 8
    private let collectionViewMinimumLineSpacing: CGFloat = 50 // Row
    private let collectionViewMinimumInteritemSpacing: CGFloat = 8 // Column
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = collectionViewMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = collectionViewMinimumInteritemSpacing
        collectionView.collectionViewLayout = flowLayout
    }
}

extension MovieFavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Movie.getFakeMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.setup(with: Movie.getFakeMovies()[indexPath.item])
        return cell
    }
}

extension MovieFavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = ((screenWidth - (2 * collectionViewSectionInset)) - collectionViewMinimumInteritemSpacing) / 2
        return CGSize(width: cellWidth, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: collectionViewSectionInset, left: collectionViewSectionInset, bottom: collectionViewSectionInset, right: collectionViewSectionInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = Movie.getFakeMovies()[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieViewController")
        vc.navigationItem.title = movie.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
