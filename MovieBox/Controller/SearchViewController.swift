//
//  SearchViewController.swift
//  MovieBox
//
//  Created by Akmaral on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//
import UIKit

final class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    let fakeData = Movie.getFakeMovies()
    let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        setUpNavBar()
    }

    func setUpNavBar() {
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.searchBarStyle = .minimal
            searchBar.placeholder = "Search MovieBox"
            searchBar.backgroundColor = UIColor.darkColor
            navigationItem.titleView = searchBar
            searchBar.isTranslucent = true
        }
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let searchVC = storyboard.instantiateViewController(withIdentifier: SearchTableViewController.uniqueID) as? SearchTableViewController {
            self.present(UINavigationController(rootViewController: searchVC), animated: false, completion: nil)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeData.count
    }


     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchMovieCell
        cell.nameLabel.text = fakeData[indexPath.row].title
        cell.movieImage.image = UIImage(named: "movieImg")
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}
