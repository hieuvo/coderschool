//
//  SwitchCell.swift
//  Yelp
//
//  Created by hvmark on 3/19/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit


class SwitchCell: FilterCell {

    static let identifider: String = "switchCell"
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: FilterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func initData(data: [String: String]) {
        super.initData(data)
        
        switchLabel.text = data["option"]
        onSwitch.on = data["value"] == "1" ? true : false
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func switchValueChanged() {
        if (delegate != nil) {
            delegate!.filterCell?(self, didValueChanged: onSwitch.on ? "1" : "0")
        }
    }
}
