//
//  FiltersViewController.swift
//  Yelp
//
//  Created by hvmark on 3/19/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit


@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didFiltersChanged: [String: AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var categorySwitchStates = [String: Bool]()
    var activeSection: Int?
    
    override func viewWillAppear(animated: Bool) {
        tableView.registerNib(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        tableView.registerNib(UINib(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        tableView.registerNib(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "categoryCell")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        if delegate != nil {
            var filters = [String: AnyObject]()
            
            filters["deal"] = sectionsData[0]["value"] == "1" ? true : false

            switch sectionsData[2]["value"]! {
                case "Best matched":
                    filters["sort"] = 0
                case "Distance":
                    filters["sort"] = 1
                case "Highest rated":
                    filters["sort"] = 2
                default: 0
            }
            
            switch sectionsData[1]["value"]! {
                case "Auto":
                    filters["distance"] = nil
                case "0.3 mile":
                    filters["distance"] = 0.3
                case "1 mile":
                    filters["distance"] = 1
                case "5 mile":
                    filters["distance"] = 5
                case "10 mile":
                    filters["distance"] = 10
                default: ()
            }

            var selectedCategories = [String]()
            for (categoryCode, isSwitchSelected) in categorySwitchStates {
                if isSwitchSelected {
                    selectedCategories.append(categoryCode)
                }
            }
            
            if selectedCategories.count > 0 {
                filters["categories"] = selectedCategories
            }
            
            delegate?.filtersViewController?(self, didFiltersChanged: filters)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var sectionsData: [[String: String]] = [
//        ["name" : "Offering a Deal", "type": "Switch"],
//        ["name" : "Sort By", "type": "Picker", "options": "a,c,b,c", "value": ""],
//        ["name" : "Distance", "type": "Picker", "options": "a,c,b,c", "value": ""],
//        ["name" : "Categories", "type": "List", "options": ""]
        ["name" : "Deal", "type": "Switch", "option": "Offering a Deal", "value": "0"],
        ["name" : "Distance", "type": "Picker", "options": "Auto,0.3 mile,1 mile,5 miles,10 miles", "value": "Auto"],
        ["name" : "Sort By", "type": "Picker", "options": "Best matched,Distance,Highest rated", "value": "Best matched"],
        ["name" : "Categories", "type": "Category"]
    ]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionsData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsData[section]["name"]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        activeSection = indexPath.section
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionData = sectionsData[indexPath.section]

        switch sectionData["type"]! {
            case "Switch":
                let cell = tableView.dequeueReusableCellWithIdentifier(SwitchCell.identifider, forIndexPath: indexPath) as! SwitchCell
                cell.initData(sectionData)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                return cell
            case "Picker":
                let cell = tableView.dequeueReusableCellWithIdentifier(PickerCell.identifider, forIndexPath: indexPath) as! PickerCell
                cell.initData(sectionData)
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.pickerView.hidden = activeSection != indexPath.section
                return cell
            case "Category":
                let cell = tableView.dequeueReusableCellWithIdentifier(CategoryCell.identifider, forIndexPath: indexPath) as! CategoryCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.delegate = self
                cell.switchStates = categorySwitchStates
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func filterCell(filterCell: FilterCell, didValueChanged value: String) {
        let indexPath = tableView.indexPathForCell(filterCell)
        var sectionData = sectionsData[indexPath!.section]
        
        switch sectionData["type"]! {
            case "Switch":
                sectionsData[indexPath!.section]["value"] = value
            case "Picker":
                sectionsData[indexPath!.section]["value"] = value
            case "Category":
                let values = value.characters.split{$0 == ","}.map(String.init) ?? []
                if values.count == 2 {
                    categorySwitchStates[values[0]] = values[1] == "1" ? true : false
                }
            default: ()
            
        }
    }
    
}
