//
//  MovieTableViewCell.swift
//  assignment1
//
//  Created by hvmark on 3/7/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import UIKit
import Toucan
import SwiftyJSON
import MBProgressHUD

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var descriptionText: UITextView!
    
    static var loadedImages = [String]()
    
    var movie: Movie? {
        didSet {
            if let m = movie {
                leftImageView.loadImageFromURLString(MoviesService.getFullImageUrl(m.image),
                    placeholderImage: nil,
                    completion: { (finished: Bool, error: NSError?) -> Void in
                        
                        if self.leftImageView.image != nil {
                            
                            self.leftImageView.image = Toucan(image: self.leftImageView.image!).resize(CGSize(width: 120, height: 120), fitMode: Toucan.Resize.FitMode.Crop).image
                            
                            if MovieTableViewCell.loadedImages.indexOf(m.image) == nil {
                                self.leftImageView.alpha = 0
                                
                                UIView.animateWithDuration(1,
                                    delay: 0,
                                    options: .CurveEaseOut,
                                    animations: {
                                        self.leftImageView.alpha = 1
                                    },
                                    completion: nil
                                )
                                MovieTableViewCell.loadedImages.append(m.image)
                            }
                        }
                    }
                )
                titleText.text = m.title
                titleText.editable = false
                titleText.scrollEnabled = false
                descriptionText.text = m.description
                descriptionText.editable = false
                descriptionText.scrollEnabled = false
            }
        }
    }
    
    override func prepareForReuse()
    {
        leftImageView.image = nil
        super.prepareForReuse()
        self.selectionStyle = .None
    }
}