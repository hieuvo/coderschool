//
//  FilterDelegateProtocol.swift
//  Yelp
//
//  Created by hvmark on 3/20/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol FilterCellDelegate {
    optional func filterCell(filterCell: FilterCell, didValueChanged value: String)
}

class FilterCell: UITableViewCell {
    var data = [String: String]()

    func initData(data: [String: String]) {
        self.data = data
    }
}