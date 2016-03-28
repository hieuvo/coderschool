//
//  TweetCell.swift
//  assignment3
//
//  Created by hvmark on 3/27/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import KFSwiftImageLoader

class TweetCell: UITableViewCell {
    static var identifier = "tweetCell"
    
    var tweetsVC: TweetsViewController!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = String(tweet.text!)
            nameLabel.text = String(tweet.user!.name!)
            screennameLabel.text = String("@" + String(tweet.user!.screenname!))
            timestampLabel.text = String(tweet.timestamp!)
            profileImage.loadImageFromURL(tweet.user!.profileUrl!)
            updateFavoriteButton(tweet.favorited)
            updateReplyButton(tweet.replied)
            updateRetweetButton(tweet.retweeted)
        }
    }
    
    @IBOutlet weak var tweetTextLabel: UITextView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private func updateFavoriteButton(favorited: Bool) {
        let image = UIImage(named: favorited ? "favorited" : "favorite")
        favoriteButton.setImage(image, forState: .Normal)
    }
    
    private func updateReplyButton(replied: Bool) {
        let image = UIImage(named: replied ? "replied" : "reply")
        replyButton.setImage(image, forState: .Normal)
    }
    
    private func updateRetweetButton(retweeted: Bool) {
        let image = UIImage(named: retweeted ? "retweeted" : "retweet")
        retweetButton.setImage(image, forState: .Normal)
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
        tweet.retweeted = !tweet.retweeted
        tweet.retweetCount += tweet.retweeted ? 1 : -1
        
        TwitterClient.sharedInstance.retweetTweetWithParams(tweet.id, retweeted: tweet.retweeted) { (success, error) -> () in
            self.updateRetweetButton(self.tweet.retweeted)
        }
    }
    
    @IBAction func replyAction(sender: AnyObject) {
        tweetsVC.replyTweet(tweet)
    }
  
    @IBAction func favoriteAction(sender: AnyObject) {
        tweet.favorited = !tweet.favorited
        tweet.favoriteCount += tweet.favorited ? 1 : -1
        
        TwitterClient.sharedInstance.favoriteTweetWithParams(tweet.id, favorited: tweet.favorited) { (success, error) -> () in
            self.updateFavoriteButton(self.tweet.favorited)
        }
    }
}
