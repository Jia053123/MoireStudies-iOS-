//
//  SaveFilesViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFilesViewController: UIViewController {
    var currentMoireId: String!
    private lazy var selectedMoireId = currentMoireId
    private lazy var moireIdToLoad = currentMoireId
    private var moireModel: MoireModel = MoireModel.init()
    private var allMoiresCache: Array<Moire>
    private var highlightedCell: SaveFileCollectionViewCell?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    required init?(coder: NSCoder) {
        allMoiresCache = moireModel.readAllMoiresSortedByLastCreated()
        super.init(coder: coder)
    }
    
    private func reloadCache() {
        allMoiresCache = moireModel.readAllMoiresSortedByLastCreated()
    }
    
    private func reloadCells() {
        self.reloadCache()
        self.collectionView.reloadData()
    }
    
    @IBAction func loadButtonPressed(_ sender: Any) {
        self.moireIdToLoad = self.selectedMoireId
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        if let smi = self.selectedMoireId {
            let success = self.moireModel.delete(moireId: smi)
            if success {
                self.reloadCells()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            print("save files controller: is being dismissed")
            if let mvc = self.presentingViewController as? MainViewController {
                mvc.moireIdToInit = self.moireIdToLoad
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
        return self.moireModel.numOfMoires() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveFileCell", for: indexPath) as! SaveFileCollectionViewCell
        if indexPath.row < self.moireModel.numOfMoires() {
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
    private func moveHighlightToCell(cell: SaveFileCollectionViewCell) {
        self.highlightedCell?.unhighlight()
        self.highlightedCell = cell
        self.highlightedCell?.highlight()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.moireModel.numOfMoires() {
            print("selected plus to create a new moire")
            let newMoire = self.moireModel.createNew()
            self.reloadCells()
            self.selectedMoireId = newMoire.id
            self.dismiss(animated: true, completion: nil)
        } else {
            print("selected cell at index: ", indexPath.row)
            let selectedCell = self.collectionView.cellForItem(at: indexPath) as! SaveFileCollectionViewCell
            self.moveHighlightToCell(cell: selectedCell)
            self.selectedMoireId = self.allMoiresCache[indexPath.row].id
        }
    }
}
