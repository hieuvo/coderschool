//
//  Film.swift
//  assignment1
//
//  Created by hvmark on 3/7/16.
//  Copyright © 2016 hvmark. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    var image: String = ""
    var title: String = ""
    var description: String = ""
    var backdropImage: String = ""
    var movieId: Int = 0
    
    var movieDetail: MovieDetail?

    init(json: JSON) {
        image = json["poster_path"].stringValue
        title = json["title"].stringValue
        description = json["overview"].stringValue
        backdropImage = json["backdrop_path"].stringValue
        movieId = json["id"].intValue
    }
}
