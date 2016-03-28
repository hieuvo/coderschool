//
//  TweetViewController.swift
//  assignment3
//
//  Created by hvmark on 3/27/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController {
    
    var tweets: [Tweet] = []
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func reloadDataForTableView() {
        tableView.reloadData()
    }
    
    func reloadTweets() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }, failure: { (error: NSError) -> () in
            print(error.localizedDescription)
        })
    }
    
    func replyTweet(tweet: Tweet) {
        performSegueWithIdentifier("newSegue", sender: tweet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        reloadTweets()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }, failure: { (error: NSError) -> () in
            print(error.localizedDescription)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let vc = navigationController.topViewController as! NewTweetViewController
            vc.tweetsVC = self
            
            if let tweet = sender as? Tweet {
                vc.tweet = tweet
            } else {
                vc.tweet = nil
            }
        }
        
        if segue.identifier == "detailSegue" {
            let cell = sender as! TweetCell
            let navigationController = segue.destinationViewController as! UINavigationController
            let vc = navigationController.topViewController as! TweetDetailViewController
            vc.tweet = cell.tweet!
            vc.tweetsVC = self
        }
    }
    
    
    @IBAction func signoutAction(sender: AnyObject) {
        TwitterClient.sharedInstance.signout()
    }
    
    @IBAction func newAction(sender: AnyObject) {
        
    }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TweetCell.identifier, forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweetsVC = self
        cell.tweet = tweet
        
        return cell
    }
}
