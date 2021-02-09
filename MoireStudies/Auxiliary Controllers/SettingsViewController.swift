//
//  SettingsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    static let FillRatioAndScaleFactor = "Fill Ratio and Scale Factor"
    static let BlackWidthAndWhiteWidth = "Black Width and White Width"
    let controlSettingItems = [FillRatioAndScaleFactor, BlackWidthAndWhiteWidth]
    static let CoreAnimation = "Core Animation"
    static let Metal = "Metal"
    let renderSettingItems = [CoreAnimation, Metal]
    
    var initSettings = InitSettings()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            if let mvc = self.presentingViewController as? MainViewController {
                mvc.initSettings = self.initSettings
                mvc.updateMainView()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        let mvc: MainViewController = segue.destination as! MainViewController
        mvc.initSettings = self.initSettings
        if mvc.isViewLoaded {
            mvc.updateMainView()
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Set a Control Scheme: "
        case 1:
            return "Set a Render Method: "
        default:
            return "Section Title"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return controlSettingItems.count
        case 1:
            return renderSettingItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")!
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = controlSettingItems[indexPath.row]
        case 1:
            cell.textLabel?.text = renderSettingItems[indexPath.row]
        default:
            cell.textLabel?.text = "Cell Title"
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch controlSettingItems[indexPath.row] {
            case SettingsViewController.FillRatioAndScaleFactor:
                self.initSettings.interfaceSetting = UISettings.controlScheme1Slider
            case SettingsViewController.BlackWidthAndWhiteWidth:
                self.initSettings.interfaceSetting = UISettings.controlScheme2Slider
            default:
                self.initSettings.interfaceSetting = UISettings.controlScheme1Slider
            }
        case 1:
            switch renderSettingItems[indexPath.row] {
            case SettingsViewController.CoreAnimation:
                self.initSettings.renderSetting = RenderSettings.coreAnimation
            case SettingsViewController.Metal:
                self.initSettings.renderSetting = RenderSettings.metal
            default:
                self.initSettings.renderSetting = RenderSettings.metal
            }
        default:
            break
        }
        if (self.presentingViewController as? MainViewController) == nil {
            self.performSegue(withIdentifier: "showMainViewFromSettingsView", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
