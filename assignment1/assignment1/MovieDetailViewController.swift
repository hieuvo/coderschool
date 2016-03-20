//
//  MovieDetailViewController.swift
//  assignment1
//
//  Created by hvmark on 3/10/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import SwiftyJSON
import KFSwiftImageLoader
import Toucan

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var bigImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var data: SwiftyJSON.JSON!
    var movie: Movie!
    
    @IBOutlet weak var descriptionText: UITextView!
    override func viewDidLoad() {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: infoView.frame.height + infoView.frame.origin.y)
    }

    func minutesToHoursMinutes (minutes : Int) -> (Int, Int) {
        return (minutes / 60, minutes % 60)
    }
    
    override func viewWillAppear(animated: Bool) {
        titleLabel.text = movie.title
        descriptionText.text = movie.description
        bigImage.loadImageFromURLString(MoviesService.getFullImageUrl(movie.image),
            placeholderImage: nil,
            completion: { (finished: Bool, error: NSError?) -> Void in
                if self.bigImage.image != nil {
//                    self.bigImage.image = Toucan(image: self.bigImage.image!).resize(CGSize(width: self.scrollView.frame.width, height: self.infoView.frame.height + self.infoView.frame.origin.y), fitMode: Toucan.Resize.FitMode.Clip).image
                }
            }
        )
        
        if movie.movieDetail == nil {
            MoviesService.loadMovieDetail(movie.movieId, callback: { (data: JSON) -> Void in
                let movieDetail = MovieDetail(json: data)
                self.movie.movieDetail = movieDetail
                
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.MediumStyle
                self.dateLabel.text = formatter.stringFromDate(NSDate(dateString: movieDetail.releaseDate))
                self.popularityLabel.text = String(Int(movieDetail.popularity))
                
                let (h, m) = self.minutesToHoursMinutes (movieDetail.runtime)
                self.runtimeLabel.text = ("\(h) hrs \(m) mins")
            })
        }
    }
}

