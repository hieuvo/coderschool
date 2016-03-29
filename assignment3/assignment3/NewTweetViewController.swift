//
//  NewTweetViewController.swift
//  assignment3
//
//  Created by hvmark on 3/28/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    var tweetsVC: TweetsViewController!
    var tweet: Tweet?

    @IBOutlet weak var charactersCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetText.delegate = self
        
        if let user = User.currentUser {
            nameLabel.text = String(user.name!)
            profileImage.loadImageFromURL(user.profileUrl!)
        }
        
        
        if let replyToUser = tweet?.user {
            tweetText.text = "@\(replyToUser.screenname!) "
            
        } else {
            tweetText.text = ""
        }

        charactersCount.text = String(140 - tweetText.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) + " chars"
    }
    
    func textViewDidChange(textView: UITextView) {
        charactersCount.text = String(140 - textView.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)) + " chars"
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 140
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
    

    @IBOutlet weak var tweetText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
