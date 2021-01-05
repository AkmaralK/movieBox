//
//  File.swift
//  MovieBox
//
//  Created by Akmaral on 12/30/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
   
    
    let searchBar = UISearchBar()
    private var data = [Person]()
    private var filteredData = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpNavBar()
        data = Person.getFake()
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
        filteredData = searchText.isEmpty ? data : data.filter { (item: Person) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }

        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as? SearchCell {
           
            cell.nameLabel?.text = filteredData[indexPath.row].name
            cell.nameLabel?.textColor = UIColor.lightGray
            return cell
        }
        
        return UITableViewCell()
    }
}
