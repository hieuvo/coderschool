//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class YelpResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate {

    var searchBar: UISearchBar!
    
    var searchSettings = YelpSearchSettings()
    
    var businesses: [Business] = []
    var searchedBusiness: [Business] = []
    var searchFilters = [String : AnyObject]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    private func doSearch() {
        var searchString: String!
        
        if searchSettings.searchString == nil {
            searchString = "Restaurants"
        } else {
            searchString = searchSettings.searchString
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let categories = searchFilters["categories"] as? [String]
        let deal = searchFilters["deal"] as? Bool ?? nil
        let sort = searchFilters["sort"] as? Int ?? 0
        let distance = searchFilters["distance"] as? Float ?? nil
        
        
        Business.searchWithTerm(searchString,
            sort: YelpSortMode(rawValue: sort),
            distance: distance,
            categories: categories,
            deals: deal,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                if businesses != nil {
                    self.businesses = businesses
                    self.tableView.reloadData()
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        )
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didFiltersChanged filters: [String : AnyObject]) {
        searchFilters = filters
        doSearch()
    }
}

// SearchBar methods
extension YelpResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}