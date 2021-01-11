//
//  File.swift
//  MovieBox
//
//  Created by Akmaral on 12/30/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class SearchTableViewController: UIViewController, UISearchBarDelegate, Alertable, UniqueIdHelper {
    
    static var uniqueID: String = "searchTableVC"
    @IBOutlet var searchTableView: UITableView!
    let searchBar = UISearchBar()
    
    private var data: [Any] = []
    
    fileprivate var searchWorkTask: DispatchWorkItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.dataSource = self
        self.searchTableView.delegate = self
        view.backgroundColor = .black
        setUpNavBar()
//        MediaType.allCases.forEach { (type) in
//            ApiService.movieLoader.getDiscoverMedia(mediaType: type, completionHandler: { (response) in
//                if (type == .movie) {
//                    self.data.append(contentsOf: response.results as! [Movie])
//                    self.searchTableView.reloadData()
//                } else {
//                    self.data.append(contentsOf: response.results as! [TvShow])
//                    self.searchTableView.reloadData()
//                }
//            }) { (msg) in
//                self.showAlert("Error", msg)
//            }
//        }
    }
    

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
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkTask?.cancel()
        
        let newTask = DispatchWorkItem { [weak self] in
            self?.searchByKeyword(queryText: searchText)
        }
        
        searchWorkTask = newTask
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: newTask)
    }
    
    fileprivate func searchByKeyword (queryText: String) {
        ApiService.shared.searchMedia(query: queryText, completionHandler: { (searchData) in
            self.data = searchData
            self.searchTableView.reloadData()
        }) { (err) in
            self.showAlert("Error", err)
        }
    }
}


extension SearchTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentData = self.data[indexPath.row]
        
        if (currentData is Movie) {
            let cell = searchTableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as! MovieSearchCell
            
            cell.nameLabel.text = (currentData as! Movie).title
            let posterPath = URL(string: (currentData as! Movie).imageUrl ?? "")
            cell.movieImageView.sd_setImage(with: posterPath, placeholderImage: UIImage(named: "placeholder.png"))
            cell.backgroundColor = UIColor.darkColor
            //cell.textLabel?.textColor = UIColor.white
        } else if (currentData is TvShow) {
            let cell1 = searchTableView.dequeueReusableCell(withIdentifier: "idTvCell", for: indexPath) as! TvSearchCell
                        
            cell1.tvNameLabel.text = (currentData as! TvShow).title
            let posterPath = URL(string: (currentData as! TvShow).imageUrl ?? "")
            cell1.tvImageView.sd_setImage(with: posterPath, placeholderImage: UIImage(named: "placeholder.png"))
            cell1.backgroundColor = UIColor.darkColor
            return cell1
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let control = UISegmentedControl(items: ["Movie", "TvShows"])
        control.backgroundColor = UIColor.white
        control.addTarget(self, action: #selector(valueChanged), for: UIControl.Event.valueChanged)
           if(section == 0){
               return control;
           }
           return nil;
       }
       
    @objc func valueChanged(segmentedControl: UISegmentedControl) -> [Any] {
           print("Coming in : \(segmentedControl.selectedSegmentIndex)")
           if (segmentedControl.selectedSegmentIndex == 0) {
            return self.data
           } else if(segmentedControl.selectedSegmentIndex == 1) {
               return self.data
           } else {
              return self.data
           }
         //  searchTableView.reloadData()
       }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 44.0
       }
}
