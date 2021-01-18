//
//  SaveFilesViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFilesViewController: UICollectionViewController {
    var selectedMoireId: String?
    private var moireModel: MoireModel = MoireModel.init()
    private var allMoiresCache: Array<Moire>
    private var highlightedCell: SaveFileCollectionViewCell?
    
    required init?(coder: NSCoder) {
        allMoiresCache = moireModel.readAllMoiresSortedByLastCreatedOrModified()
        super.init(coder: coder)
    }
    
    private func reloadCache() {
        allMoiresCache = moireModel.readAllMoiresSortedByLastCreatedOrModified()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moireModel.numOfMoires() + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveFileCell", for: indexPath) as! SaveFileCollectionViewCell
        if indexPath.row < self.moireModel.numOfMoires() {
            let m = self.allMoiresCache[indexPath.row]
            cell.setUp(previewImage: m.preview)
            if m.id == self.selectedMoireId {
                self.highlightedCell = cell
                self.highlightedCell?.highlight()
            }
        } else {
            cell.setUp(previewImage: UIImage(systemName: "plus.rectangle")!)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.moireModel.numOfMoires() {
            print("selected plus")
            let newMoire = self.moireModel.createNew()
            self.reloadCache()
//            self.collectionView.reloadData()
            self.selectedMoireId = newMoire.id
        } else {
            print("selected cell at index: ", indexPath.row)
            self.highlightedCell?.unhighlight()
            let selectedCell = self.collectionView.cellForItem(at: indexPath)
            self.highlightedCell = selectedCell as? SaveFileCollectionViewCell
            assert(highlightedCell != nil)
            self.highlightedCell?.highlight()
            self.selectedMoireId = self.allMoiresCache[indexPath.row].id
        }
        performSegue(withIdentifier: "showMainViewFromSaveFilesView", sender: self)
    }
    
    func setupMainViewController(mainViewController: MainViewController) {
        mainViewController.moireIdToInit = self.selectedMoireId
        mainViewController.resetMainView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            print("save files controller: is being dismissed")
            if let mvc = self.presentingViewController as? MainViewController {
                self.setupMainViewController(mainViewController: mvc)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        let mvc: MainViewController = segue.destination as! MainViewController
        self.setupMainViewController(mainViewController: mvc)
    }
}
