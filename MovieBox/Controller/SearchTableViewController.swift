//
//  File.swift
//  MovieBox
//
//  Created by Akmaral on 12/30/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class SearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, Alertable, UniqueIdHelper {
    
  
    static var uniqueID: String = "searchTableVC"
    @IBOutlet var searchTableView: UITableView!
    let searchBar = UISearchBar()
    private var filteredData = [ResultMovie]()
    private var filteredTV = [ResultTV]()
    private var movies = [ResultMovie]()
    private var movieLoader = MovieLoader()
    private var tvLoader = TVLoader()
    private var tvShows = [ResultTV]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
         view.backgroundColor = .black
              NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateMovies),
                name: Notification.Name("movieNotification"),
                object: nil)
         movieLoader.getMovieDetails()
         tvLoader.getTVDetails()
         setUpNavBar()
         filteredData = movies
        // filteredTV = tvShows
    }
    
    @objc func updateMovies(notification: Notification) {
        if let movies = notification.object as? [ResultMovie] {
            self.movies = movies
            self.filteredData = movies
            searchTableView.reloadData()
        } else if let tvShows = notification.object as? [ResultTV] {
                self.tvShows = tvShows
               // self.filteredTV = tvShows
            searchTableView.reloadData()
            }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            let control = UISegmentedControl(items: ["Movie","TV"])
//        control.backgroundColor = UIColor.lightGray
//            control.addTarget(self, action: Selector(("valueChanged:")), for: UIControl.Event.valueChanged)
//            if(section == 0){
//                return control;
//            }
//            return nil;
//        }
//
//        func valueChanged(segmentedControl: UISegmentedControl) {
//            print("Coming in : \(segmentedControl.selectedSegmentIndex)")
//            if(segmentedControl.selectedSegmentIndex == 0){
//                self.filteredData = self.movies
//            } else if(segmentedControl.selectedSegmentIndex == 1){
//                self.filteredData = self.movies
//            } else if(segmentedControl.selectedSegmentIndex == 2){
//                self.filteredTV = self.tvShows
//            }
//            self.searchTableView.reloadData()
//        }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 44.0
//        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func setUpNavBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by "
        searchBar.backgroundColor = UIColor.darkColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.lightGray
        navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredData = movies.filter({$0.originalTitle.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        self.searchTableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (filteredData.count + tvShows.count)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < filteredData.count {
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! MovieSearchCell
                cell.nameLabel.text = filteredData[indexPath.row].originalTitle
                let posterPath = filteredData[indexPath.row].posterPath
                cell.movieImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)"), placeholderImage: UIImage(named: "placeholder.png"))
                cell.backgroundColor = UIColor.darkColor
                cell.textLabel?.textColor = UIColor.white
                return cell
        } else  {
            let cell1 = searchTableView.dequeueReusableCell(withIdentifier: "idTvCell", for: indexPath) as! TvSearchCell
                        cell1.tvNameLabel.text = tvShows[indexPath.row - filteredData.count].originalName
                        let posterPath = tvShows[indexPath.row - filteredData.count].posterPath
                        cell1.tvImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)"), placeholderImage: UIImage(named: "placeholder.png"))
                        cell1.backgroundColor = UIColor.darkColor
                        return cell1
        }
        
   }
     
}
