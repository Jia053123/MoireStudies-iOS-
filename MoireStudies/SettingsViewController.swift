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
    var settings = Settings()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Choose a Control Scheme: "
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
        case "Fill Ratio and Scale Factor":
            self.settings.interfaceSetting = UISettings.controlScheme1Slider
        case "Black Width and White Width":
            self.settings.interfaceSetting = UISettings.controlScheme2Slider
        default:
            self.settings.interfaceSetting = UISettings.controlScheme1Slider
        }
        performSegue(withIdentifier: "showMainView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mvc: MainViewController = segue.destination as! MainViewController
        mvc.settings = self.settings
    }
}
