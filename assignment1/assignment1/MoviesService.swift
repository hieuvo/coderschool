//
//  MovieService.swift
//  assignment1
//
//  Created by hvmark on 3/13/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import Foundation
import SwiftyJSON

class MoviesService {
    static var apiKey: String = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    static func loadMovies(endPoint: String, callback: (data: JSON) -> Void)
    {
        let urlString = "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)"
        makeRequest(urlString, callback: callback)
    }

    static func loadMovieDetail(movieId: Int, callback: (data: JSON) -> Void)
    {
        let urlString = "http://api.themoviedb.org/3/movie/\(movieId)?api_key=\(apiKey)"
        makeRequest(urlString, callback: callback)
    }
    
    static func makeRequest(urlString: String, callback: (data: JSON) -> Void)
    {
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            guard error == nil else  {
                print("error loading from URL", error!)
                return
            }
            
            let jsonData = JSON(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                callback(data: jsonData)
            })
        }
        task.resume()
    }
    
    static func getFullImageUrl(imageName: String) -> String {
        return "https://image.tmdb.org/t/p/w342" + imageName;
    }
}