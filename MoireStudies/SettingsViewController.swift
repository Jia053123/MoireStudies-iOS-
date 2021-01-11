//
//  SettingsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    let schemeSettingItems = ["Fill Ratio and Scale Factor", "Black Width and White Width"]
    let actionItems = ["Reset Moire"]
    var initSettings = InitSettings()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Set a Control Scheme: "
        case 1:
            return "Actions: "
        default:
            return "Section Title"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return schemeSettingItems.count
        case 1:
            return actionItems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")!
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = schemeSettingItems[indexPath.row]
        case 1:
            cell.textLabel?.text = actionItems[indexPath.row]
        default:
            cell.textLabel?.text = "Cell Title"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch schemeSettingItems[indexPath.row] {
            case "Fill Ratio and Scale Factor":
                self.initSettings.interfaceSetting = UISettings.controlScheme1Slider
            case "Black Width and White Width":
                self.initSettings.interfaceSetting = UISettings.controlScheme2Slider
            default:
                self.initSettings.interfaceSetting = UISettings.controlScheme1Slider
            }
        case 1:
            self.initSettings.resetMoire = true
        default:
            break
        }
        performSegue(withIdentifier: "showMainView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mvc: MainViewController = segue.destination as! MainViewController
        mvc.initSettings = self.initSettings
    }
}
