//
//  SaveFilesViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFilesViewController: UICollectionViewController {
    var currentMoireId: String?
    private var moireModel: MoireModel = MoireModel.init()
//    private var allMoires: Array<Moire>
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        do {
//            guard let data = UserDefaults.standard.value(forKey: "Moire") as? Data else {throw NSError()}
//            self.moireModel.moires.append(try PropertyListDecoder().decode(Moire.self, from: data))
//        } catch {
//            print("problem loading saved moire; loading the default")
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("save files controller: view will disappear")
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            let mvc = self.presentingViewController as? MainViewController
            mvc?.resumeMoire()
        }
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
            let m = self.moireModel.readAllMoiresSortedByLastCreatedOrModified()[indexPath.row] // TODO: you are reading every file just to output one file
            cell.setUp(previewImage: m.preview)
        } else {
            cell.setUp(previewImage: UIImage(systemName: "plus.rectangle")!)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.moireModel.numOfMoires() {
            // plus is selected
        } else {
            print("TODO: save file selected")
        }
    }
}
