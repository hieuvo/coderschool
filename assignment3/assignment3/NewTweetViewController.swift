//
//  NewTweetViewController.swift
//  assignment3
//
//  Created by hvmark on 3/28/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    var tweetsVC: TweetsViewController!
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = User.currentUser {
            nameLabel.text = String(user.name!)
            profileImage.loadImageFromURL(user.profileUrl!)
        }
        
        if let replyToUser = tweet?.user {
            tweetText.text = "@\(replyToUser.screenname!) "
        }
    }
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newAction(sender: AnyObject) {
        var params : [String: AnyObject] = ["status" : tweetText.text!]
        
        if let tweet = tweet {
            params["in_reply_to_status_id"] = "\(tweet.id!)"
        }
        
        TwitterClient.sharedInstance.updateTweet(params, success: { (tweet: Tweet) in
            self.tweetsVC.reloadTweets()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBOutlet weak var tweetText: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
