//
//  ViewController.swift
//  assignment1
//
//  Created by hvmark on 3/5/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class MoviesViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate
{
    @IBOutlet weak var tableView: MovieTableView!

    var refreshControl: UIRefreshControl!
    var searchBar: UISearchBar!
    var networkErrorView: UIView!
    var endPoint: String = "now_playing"
    
    func refreshControlAction(refreshControl: UIRefreshControl)
    {
        if Network().isConnectedToNetwork() == false {
            initNetworkError()
            refreshControl.endRefreshing()
            return
        }
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        MoviesService.loadMovies(endPoint, callback: {(data: JSON) -> Void in
            self.tableView.addData(data["results"])
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let vc = segue.destinationViewController as! MovieDetailViewController
        let indexPath = tableView.indexPathForCell(sender as! MovieTableViewCell)!
        searchBar.resignFirstResponder()
        tableView.prepareDataForDetailView(vc, indexPath: indexPath)
        vc.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        initSearchBar()
        initTableView()
        initRefreshControl()
        
        super.viewWillAppear(animated)
    }
    
    func initNetworkError()
    {
        if networkErrorView == nil {
            let bounds = UIScreen.mainScreen().bounds
            networkErrorView = UIView(frame: CGRectMake(0 , -25, bounds.size.width, 50))
            networkErrorView.backgroundColor = UIColor.blueColor()
            
            let errorText = UILabel(frame: CGRectMake(0 , 0, bounds.size.width, 50))
            
            errorText.textColor = UIColor.whiteColor()
            errorText.textAlignment = NSTextAlignment.Center
            errorText.numberOfLines = 1
            errorText.text = "Network error"
            networkErrorView.addSubview(errorText)
        }
        
        self.networkErrorView.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width/2, y: -25)
        
        UIView.animateWithDuration(1.5,
            delay: 0,
            options: .CurveEaseOut,
            animations: {
                self.networkErrorView.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width/2, y: 25)
            },
            completion: nil
        )
        
        UIView.animateWithDuration(1.5,
            delay: 3,
            options: .CurveEaseOut,
            animations: {
                self.networkErrorView.center = CGPoint(x: UIScreen.mainScreen().bounds.size.width/2, y: -25)
            },
            completion: nil
        )
        
        view.addSubview(networkErrorView)
    }
    
    func initRefreshControl()
    {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func initSearchBar()
    {
        if searchBar == nil {
            searchBar = UISearchBar()
            searchBar.sizeToFit()
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.searchBarStyle = .Minimal
            navigationItem.titleView = searchBar
        }
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func initTableView()
    {
//        tableView.separatorStyle = .None
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        tableView.showResultForSearchText(searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem)
    {

    }

}

