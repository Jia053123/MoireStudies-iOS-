//
//  SaveFilesViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFilesViewController: UIViewController {
    var initiallySelectedMoireId: String?
    private var _selectedMoireId: String?
    private var selectedMoireId: String? {
        get {return _selectedMoireId ?? initiallySelectedMoireId}
        set {
            _selectedMoireId = newValue
            if let smi = _selectedMoireId {
                // manage highlight
                let index = self.allMoiresCache.firstIndex(where: {$0.id == smi})!
                let cellToHighlight = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0))
                self.moveHighlightToCell(cell: cellToHighlight as? SaveFileCollectionViewCell)
            }
        }
    }
    private lazy var moireIdToLoad: String? = initiallySelectedMoireId // The moire to be edited by main view
    private var moireModel: MoireModel!
    private var allMoiresCache: Array<Moire>! // supposed to be in perfect sync with the files stored on disk at all time
    private weak var highlightedCell: SaveFileCollectionViewCell?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    private func setUpWithModelAndMoireId(moireModel: MoireModel = LocalMoireModel.init()) {
        self.moireModel = moireModel
        self.reloadCache()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setUpWithModelAndMoireId()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpWithModelAndMoireId()
    }
    
    init?(coder: NSCoder, mockMoireModel: MoireModel) {
        super.init(coder: coder)
        self.setUpWithModelAndMoireId(moireModel: mockMoireModel)
    }
    
    private func reloadCache() {
        allMoiresCache = self.moireModel.readAllMoiresSortedByLastCreated()
    }
    
    private func reloadCells() {
        self.reloadCache()
        self.collectionView.reloadData()
    }
    /**
     - Parameters:
        - cell: the cell to highlight; if nil, then no cell will be in highlighted state
     */
    private func moveHighlightToCell(cell: SaveFileCollectionViewCell?) {
        self.highlightedCell?.unhighlight()
        self.highlightedCell = cell
        self.highlightedCell?.highlight()
    }
    
    private func createNewMoire() {
        let newMoire = self.moireModel.createNewDemoMoire()
        self.reloadCells()
        self.selectedMoireId = newMoire.id
    }
    
    private func dismissAndLoadSelectedMoire() {
        self.moireIdToLoad = self.selectedMoireId
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadButtonPressed(_ sender: Any) {
        self.dismissAndLoadSelectedMoire()
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let smi = self.selectedMoireId {
            let index = self.allMoiresCache.firstIndex(where: {$0.id == smi})!
            let success = self.moireModel.delete(moireId: smi)
            if success {
                self.reloadCells()
                guard allMoiresCache.count != 0 else {
                    self.createNewMoire()
                    self.dismissAndLoadSelectedMoire()
                    return
                }
                let indexToSelect: Int
                if index == 0 {
                    indexToSelect = 0
                } else {
                    indexToSelect = index - 1
                }
                self.selectedMoireId = self.allMoiresCache[indexToSelect].id
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            if let mvc = self.presentingViewController as? MainViewController {
                if let mtl = self.moireIdToLoad, let _ = self.moireModel.read(moireId: mtl) {
                    mvc.moireIdToInit = self.moireIdToLoad
                } else {
                    mvc.moireIdToInit = self.selectedMoireId
                }
                mvc.updateMainView()
            }
        }
    }
}

extension SaveFilesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMoiresCache.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveFileCell", for: indexPath) as! SaveFileCollectionViewCell
        if indexPath.row < self.allMoiresCache.count {
            let m = self.allMoiresCache[indexPath.row]
            cell.setUp(previewImage: m.preview)
            if m.id == self.selectedMoireId {
                self.moveHighlightToCell(cell: cell)
            }
        } else {
            cell.setUp(previewImage: UIImage(systemName: "plus.rectangle")!)
        }
        return cell
    }
}

extension SaveFilesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.allMoiresCache.count {
            print("selected plus to create a new moire")
            self.createNewMoire()
            self.dismissAndLoadSelectedMoire()
        } else {
            print("selected cell at index: ", indexPath.row)
            self.selectedMoireId = self.allMoiresCache[indexPath.row].id
        }
    }
}
