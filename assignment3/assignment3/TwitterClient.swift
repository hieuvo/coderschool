//
//  TwitterApi.swift
//  assignment3
//
//  Created by hvmark on 3/26/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "YeQsXQBwR9DSW736s1aTSz93H", consumerSecret: "faB5Div4hfJ5fnNZ6tCW7K8s9ipFKiB4MJxwWedgs2ew4v0WzX")
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                success(user)
            },
            failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            }
        )
    }
    
    func signout() {
        deauthorize()
        User.currentUser = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidSingout, object: nil)
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> () ) {
        GET("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("account: \(response)")
                
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            },
            failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
            }
        )
    }
    
    var loginSucess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(sucess: () -> (), failure: (NSError) -> ()) {
        loginSucess = sucess
        loginFailure = failure

        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)
                print("I got a token")
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
            print("I have got access token")

            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
//                self.currentUser = user
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
            self.loginSucess?()
            
        }, failure: {(error: NSError!) -> Void in
            self.loginFailure?(error)
        })
    }
    
    func updateTweet(params: NSDictionary?,success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?)-> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func favoriteTweetWithParams(tweetId: NSNumber, favorited: Bool, completion: (success: Bool, error: NSError?) -> ()) {
        POST("1.1/favorites/\(favorited ? "create" : "destroy").json",
            parameters:["id": "\(tweetId)"],
            progress: nil,
            success:  { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(success: true, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Unable to favorite tweet: \(error)")
                completion(success: false, error: error)
        })
    }
    
    func retweetTweetWithParams(tweetId: NSNumber, retweeted: Bool, completion: (success: Bool, error: NSError?) -> ()) {
        POST("1.1/statuses/\(retweeted ? "retweet" : "unretweet")/\(tweetId).json", parameters: nil,
            progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                completion(success: true, error:nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Unable to retweet tweet: \(error)")
                completion(success: false, error: error)
        })
    }
}
