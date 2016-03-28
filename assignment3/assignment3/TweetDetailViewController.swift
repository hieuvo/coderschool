//
//  TweetDetailViewController.swift
//  assignment3
//
//  Created by hvmark on 3/28/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweetsVC: TweetsViewController!
    
    var tweet: Tweet!

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet != nil {
            tweetText.text = String(tweet.text!)
            nameLabel.text = String(tweet.user!.name!)
            countLabel.text = String(tweet.favoriteCount) + " favorites, " + String(tweet.retweetCount) + " retweets"
            screennameLabel.text = String("@" + String(tweet.user!.screenname!))
            profileImage.loadImageFromURL(tweet.user!.profileUrl!)
            updateFavoriteButton(tweet.favorited)
            updateRetweetButton(tweet.retweeted)
            updateReplyButton(tweet.replied)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(sender: AnyObject) {
        tweetsVC.reloadDataForTableView()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func updateReplyButton(replied: Bool) {
        let image = UIImage(named: replied ? "replied" : "reply")
        replyButton.setImage(image, forState: .Normal)
    }

    private func updateFavoriteButton(favorited: Bool) {
        let image = UIImage(named: favorited ? "favorited" : "favorite")
        favoriteButton.setImage(image, forState: .Normal)
    }
    
    private func updateRetweetButton(retweeted: Bool) {
        let image = UIImage(named: retweeted ? "retweeted" : "retweet")
        retweetButton.setImage(image, forState: .Normal)
    }
    
    @IBAction func replyAction(sender: AnyObject) {
        tweetsVC.replyTweet(tweet)
    }

    @IBAction func retweetAction(sender: AnyObject) {
        tweet.retweeted = !tweet.retweeted
        tweet.retweetCount += tweet.retweeted ? 1 : -1
        countLabel.text = String(tweet.favoriteCount) + " favorites, " + String(tweet.retweetCount) + " retweets"
            
        TwitterClient.sharedInstance.retweetTweetWithParams(tweet.id, retweeted: tweet.retweeted, completion: { (success, error) -> () in
            self.updateRetweetButton(self.tweet.retweeted)
        })
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        tweet.favorited = !tweet.favorited
        tweet.favoriteCount += tweet.favorited ? 1 : -1
        countLabel.text = String(tweet.favoriteCount) + " favorites, " + String(tweet.retweetCount) + " retweets"
        
        TwitterClient.sharedInstance.favoriteTweetWithParams(tweet.id, favorited: tweet.favorited) { (success, error) -> () in
            self.updateFavoriteButton(self.tweet.favorited)
        }
    }
}
