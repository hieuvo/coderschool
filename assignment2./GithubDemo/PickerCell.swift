//
//  DropdownCell.swift
//  Yelp
//
//  Created by hvmark on 3/19/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class PickerCell: FilterCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    static let identifider: String = "pickerCell"
    
    weak var delegate: FilterCellDelegate?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var currentValueLabel: UILabel!
    
    var pickerValues = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.dataSource = self
        pickerView.delegate = self
//        pickerView.hidden = true
    }
    
    override func initData(data: [String: String]) {
        super.initData(data)
        
        pickerValues = data["options"]?.characters.split{$0 == ","}.map(String.init) ?? []
        pickerView.reloadComponent(0)
        currentValueLabel.text = data["value"]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerValues.count >= row {
            currentValueLabel.text = pickerValues[row]
            
            if (delegate != nil) {
                delegate!.filterCell?(self, didValueChanged: pickerValues[row])
            }
        }
    }
    
    
//    static var expandedHeight: CGFloat { get { return 200 } }
//    static var defaultHeight: CGFloat  { get { return 44  } }
//    var isObserving = false;
//    
//    func checkHeight() {
//        pickerView.hidden = (frame.size.height < PickerCell.expandedHeight)
//    }
//    
//    func watchFrameChanges() {
//        if !isObserving {
//            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Initial], context: nil)
//            isObserving = true;
//        }
//    }
//    
//    func ignoreFrameChanges() {
//        if isObserving {
//            removeObserver(self, forKeyPath: "frame")
//            isObserving = false;
//        }
//    }
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if keyPath == "frame" {
//            checkHeight()
//        }
//    }
}
