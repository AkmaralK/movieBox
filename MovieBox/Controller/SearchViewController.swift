//
//  SearchViewController.swift
//  MovieBox
//
//  Created by Akmaral on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    let fakeData = Movie.getFakeMovies()
    var searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search MovieBox"
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeData.count
    }


     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchMovieCell
        cell.nameLabel.text = fakeData[indexPath.row].name
        cell.movieImage.image = UIImage(named: "movieImg")
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}
