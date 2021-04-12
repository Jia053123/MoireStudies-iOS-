//
//  SettingsViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-04.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController { // TODO: now we have a lot of scattered info. create a setting item struct type to consolidate
    @IBOutlet weak var tableView: UITableView!
    var initSettings = InitSettings()
    private static let FillRatioAndScaleFactor = "Fill Ratio and Scale Factor"
    private static let BlackWidthAndWhiteWidth = "Black Width and White Width"
    private static let CompositeControls = "Composite Controls (Metal Only)"
    private let controlSettingItems = [FillRatioAndScaleFactor, BlackWidthAndWhiteWidth, CompositeControls]
    private static let CoreAnimation = "Core Animation"
    private static let Metal = "Metal"
    private let renderSettingItems = [CoreAnimation, Metal]
    private static let Developer = "Built by Jialiang Xiang in Toronto (jialiangx2021@outlook.com)"
    private let creditItems = [Developer]
    
    private var selectedIndexPathSec0: IndexPath?
    private var selectedIndexPathSec1: IndexPath?
    @IBOutlet weak var Done: UIButton!
    
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
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if (self.presentingViewController as? MainViewController) == nil {
            self.performSegue(withIdentifier: "showMainViewFromSettingsView", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Set a Control Scheme: "
        case 1:
            return "Set a Render Method: "
        case 2:
            return "Credit"
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
        case 2:
            return creditItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell")!
        switch indexPath.section {
        case 0:
            cell.textLabel!.text = controlSettingItems[indexPath.row]
        case 1:
            cell.textLabel!.text = renderSettingItems[indexPath.row]
        case 2:
            cell.textLabel!.text = creditItems[indexPath.row]
        default:
            cell.textLabel!.text = "Cell Title"
        }
        // tick the current settings
        switch indexPath.section {
        case 0:
            let selectedSetting = self.initSettings.interfaceSetting
            switch (selectedSetting, cell.textLabel!.text) {
            case (CtrlSchemeSettings.controlScheme1Slider, SettingsViewController.FillRatioAndScaleFactor),
                 (CtrlSchemeSettings.controlScheme2Slider, SettingsViewController.BlackWidthAndWhiteWidth),
                 (CtrlSchemeSettings.controlScheme3Slider, SettingsViewController.CompositeControls):
                self.selectedIndexPathSec0 = indexPath
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            default:
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        case 1:
            let selectedSetting = self.initSettings.renderSetting
            switch (selectedSetting, cell.textLabel!.text) {
            case (RenderSettings.coreAnimation, SettingsViewController.CoreAnimation),
                 (RenderSettings.metal, SettingsViewController.Metal):
                self.selectedIndexPathSec1 = indexPath
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            default:
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        default:
            break
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let sip0 = self.selectedIndexPathSec0 {
                tableView.cellForRow(at: sip0)?.accessoryType = UITableViewCell.AccessoryType.none
            }
            self.selectedIndexPathSec0 = indexPath
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
            switch controlSettingItems[indexPath.row] {
            case SettingsViewController.FillRatioAndScaleFactor:
                self.initSettings.interfaceSetting = CtrlSchemeSettings.controlScheme1Slider
            case SettingsViewController.BlackWidthAndWhiteWidth:
                self.initSettings.interfaceSetting = CtrlSchemeSettings.controlScheme2Slider
            case SettingsViewController.CompositeControls:
                self.initSettings.interfaceSetting = CtrlSchemeSettings.controlScheme3Slider
                if self.initSettings.renderSetting != RenderSettings.metal {
                    self.initSettings.renderSetting = RenderSettings.metal
                    self.tableView.reloadSections(IndexSet.init(integer: 1), with: UITableView.RowAnimation.none)
                }
            default:
                self.initSettings.interfaceSetting = CtrlSchemeSettings.controlScheme1Slider
            }
        case 1:
            if let sip1 = self.selectedIndexPathSec1 {
                tableView.cellForRow(at: sip1)?.accessoryType = UITableViewCell.AccessoryType.none
            }
            self.selectedIndexPathSec1 = indexPath
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            
            switch renderSettingItems[indexPath.row] {
            case SettingsViewController.CoreAnimation:
                self.initSettings.renderSetting = RenderSettings.coreAnimation
                if self.initSettings.interfaceSetting == CtrlSchemeSettings.controlScheme3Slider {
                    self.initSettings.interfaceSetting = CtrlSchemeSettings.controlScheme1Slider
                    self.tableView.reloadSections(IndexSet.init(integer: 0), with: UITableView.RowAnimation.none)
                }
            case SettingsViewController.Metal:
                self.initSettings.renderSetting = RenderSettings.metal
            default:
                self.initSettings.renderSetting = RenderSettings.metal
            }
        default:
            break
        }
    }
}
