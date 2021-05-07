//
//  ViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-25.
//

import Foundation
import UIKit

class MainViewController: MoireManagingController {
    @IBOutlet weak var buttonsContainerView: UIView!
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var fileButton: UIButton!
    @IBOutlet weak var newPatternButton: UIButton!
    @IBOutlet weak var newHighDegCtrlButton: UIButton!
    @IBOutlet weak var dialogueContainerView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dialogueContent: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup Buttons
        self.dialogueContainerView.isHidden = true
        self.view.bringSubviewToFront(dialogueContainerView)
        self.view.bringSubviewToFront(buttonsContainerView)
    }
    
    @IBAction func newPatternButtonPressed(_ sender: Any) {
        _ = self.createPattern(callerId: nil, newPattern: Pattern.randomDemoPattern())
    }
    
    @IBAction func gearButtonPressed(_ sender: Any) {
        _ = self.saveMoire()
        performSegue(withIdentifier: "showSettingsView", sender: self.gearButton)
    }
    
    @IBAction func fileButtonPressed(_ sender: Any) {
        _ = self.saveMoire()
        performSegue(withIdentifier: "showSaveFilesView", sender: self.fileButton)
    }
    
    @IBAction func newHighDegCtrlButtonPressed(_ sender: Any) {
        self.enterSelectionMode()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let selectedIndexes = self.patternsSelector.selectedPatternIndexes
        let success = self.createHighDegControl(type: .basicScheme, indexesOfPatternsToControl: selectedIndexes)
        if !success {
            print("failed to create new control")
        }
        self.exitSelectionMode()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.exitSelectionMode()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = sender as? UIButton {
            switch s {
            case self.gearButton!:
                let svc: SettingsViewController = segue.destination as! SettingsViewController
                if let currentSettings = self.configurations {
                    svc.initConfig = currentSettings
                }
            case self.fileButton!:
                let sfvc: SaveFilesViewController = segue.destination as! SaveFilesViewController
                sfvc.initiallySelectedMoireId = self.currentMoire?.id
            default:
                break
            }
        }
        self.pauseMoire()
    }
    
    func pauseMoire() {
        self.moireDisplayer.viewControllerLosingFocus()
    }
    
    func enterSelectionMode() {
        self.patternsSelector.enterSelectionMode()
        self.dialogueContent.text = Constants.Text.highDegreeControlCreationInstruction
        self.dialogueContainerView.isHidden = false
        
        self.newPatternButton.isEnabled = false
        self.gearButton.isEnabled = false
        self.fileButton.isEnabled = false
        self.newHighDegCtrlButton.isEnabled = false
    }

    func exitSelectionMode() {
        self.patternsSelector.exitSelectionMode()
        self.dialogueContainerView.isHidden = true
        
        self.newPatternButton.isEnabled = true
        self.gearButton.isEnabled = true
        self.fileButton.isEnabled = true
        self.newHighDegCtrlButton.isEnabled = true
    }
}

