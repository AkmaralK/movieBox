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
    private var filteredData = [Movie]()
    private var filteredTV = [TvShow]()
    private var movies = [Movie]()
    private var tvShows = [TvShow]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        view.backgroundColor = .black
        
        MediaType.allCases.forEach { (type) in
            ApiService.movieLoader.getDiscoverMedia(mediaType: type, completionHandler: { (response) in
                if (type == .movie) {
                    self.movies = response.results as! [Movie]
                    self.searchTableView.reloadData()
                } else {
                    self.tvShows = response.results as! [TvShow]
                    self.searchTableView.reloadData()
                }
            }) { (msg) in
                self.showAlert("Error", msg)
            }
        }
        
        setUpNavBar()
        filteredData = movies
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
        
        filteredData = movies.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
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
            let data = filteredData[indexPath.row]
            
            cell.nameLabel.text = data.title
            let posterPath = URL(string: filteredData[indexPath.row].imageUrl ?? "")
            cell.movieImageView.sd_setImage(with: posterPath, placeholderImage: UIImage(named: "placeholder.png"))
            cell.backgroundColor = UIColor.darkColor
            cell.textLabel?.textColor = UIColor.white
            return cell
        } else  {
            let cell1 = searchTableView.dequeueReusableCell(withIdentifier: "idTvCell", for: indexPath) as! TvSearchCell
            
            let data = tvShows[indexPath.row - filteredData.count]
            
            cell1.tvNameLabel.text = data.title
            let posterPath = URL(string: data.imageUrl ?? "")
            cell1.tvImageView.sd_setImage(with: posterPath, placeholderImage: UIImage(named: "placeholder.png"))
            cell1.backgroundColor = UIColor.darkColor
            return cell1
        }
        
    }
    
}
