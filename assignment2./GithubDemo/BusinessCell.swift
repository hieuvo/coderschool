//
//  BusinessCell.swift
//  GithubDemo
//
//  Created by hvmark on 3/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import HCSStarRatingView

class BusinessCell: UITableViewCell {
    static let identifier:String = "businessCell"
    
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            reviewCountLabel.text = String(business.reviewCount!)
            distanceLabel.text = business.distance
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            ratingView.value = CGFloat(business.rating!)
            
            if (business.imageURL != nil) {
                mainImage.setImageWithURL(business.imageURL!)
            }
        }
    }
    
    override func prepareForReuse()
    {
        mainImage.image = nil
        super.prepareForReuse()
        self.selectionStyle = .None
    }
}