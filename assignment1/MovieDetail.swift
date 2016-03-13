//
//  Film.swift
//  assignment1
//
//  Created by hvmark on 3/7/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import Foundation
import SwiftyJSON

class MovieDetail {
    var runtime: Int = 0
    var releaseDate: String = ""
    var popularity: Float = 0
    
    init(json: JSON) {
        runtime = json["runtime"].intValue
        releaseDate = json["release_date"].stringValue
        popularity = json["popularity"].floatValue
    }
}
