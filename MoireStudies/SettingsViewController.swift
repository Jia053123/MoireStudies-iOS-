//
//  SettingsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    let schemeSettingItems = ["fill ratio and scale factor", "black width and white width"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schemeSettingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")!
        cell.textLabel?.text = schemeSettingItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch schemeSettingItems[indexPath.row] {
        case "fill ratio and scale factor":
            Settings.interfaceSetting = UISettings.controlScheme1Slider
        case "black width and white width":
            Settings.interfaceSetting = UISettings.controlScheme2Slider
        default:
            Settings.interfaceSetting = UISettings.controlScheme1Slider
        }
    }
}
