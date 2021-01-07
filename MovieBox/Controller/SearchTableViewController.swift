//
//  File.swift
//  MovieBox
//
//  Created by Akmaral on 12/30/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class SearchTableViewController: UITableViewController, UISearchBarDelegate, Alertable {
    

 
    let searchBar = UISearchBar()
    private var filteredData = [MoviesSectionTypes: DataSection<MediaData>]()
    
    private var data: [MoviesSectionTypes: DataSection<MediaData>] = MoviesSectionTypes.allCases.reduce(into: [MoviesSectionTypes: DataSection]()) {
        $0[$1] = DataSection(data: [], isLoading: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpNavBar()
        self.loadData()
        filteredData = data
        tableView.register(SearchCell.self, forCellReuseIdentifier: "idCell")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func setUpNavBar() {
        searchBar.sizeToFit()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by "
        searchBar.backgroundColor = UIColor.darkColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.lightGray
        navigationItem.titleView = searchBar
        searchBar.isTranslucent = true
    }
    
    private func loadData () {
        MoviesSectionTypes.allCases.forEach { (type) in
            ApiService.movieLoader.loadMovieShowBySection(mediaType: type.mediaType, section: type, complitionHandler: { (moviesResponse) in
                self.data[type]!.data = moviesResponse.results
                self.data[type]?.isLoading = false
                self.data[type]?.next(totalPages: moviesResponse.total_pages)
                self.tableView.reloadData()
            }) { (msg) in
                self.showAlert("Error", msg)
            }
        }
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//            searchBar.showsCancelButton = true
//        }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//            searchBar.showsCancelButton = false
//            searchBar.text = ""
//            searchBar.resignFirstResponder()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filteredData = searchText.isEmpty ? data : data.filter { (item: MediaData) -> Bool in
//            return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }

        self.loadData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.keys.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as? SearchCell {
            let movieData = self.data.values[data.values.index(data.values.startIndex, offsetBy: indexPath.row)]
            cell.nameLabel?.text = "title"; // movieData.data[indexPath.row].title
        cell.movieImageView?.sd_setImage(with: URL(string: movieData.data[indexPath.row].imageUrl ?? ""), placeholderImage: UIImage(named: "moviePlaceholder"))
        cell.selectionStyle = .none
        return cell
        }
      return UITableViewCell()
    }
}

