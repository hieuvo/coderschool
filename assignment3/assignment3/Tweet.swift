//
//  Tweet.swift
//  assignment3
//
//  Created by hvmark on 3/26/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int!
    var text: NSString?
    var timestamp: NSDate?
    var favorited: Bool = false
    var replied: Bool = false
    var retweeted: Bool = false
    var favoriteCount: Int = 0
    var retweetCount: Int = 0
    
    var user: User?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        id = dictionary["id"] as! Int
        favorited = (dictionary["favorited"] as! Int) == 0 ? false : true
        retweeted = (dictionary["retweeted"] as! Int) == 0 ? false : true
        favoriteCount = dictionary["favorite_count"] as! Int
        retweetCount = dictionary["retweet_count"] as! Int
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}

