//
//  SaveFilesViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFilesViewController: UICollectionViewController {
    var moires: Array<Moire> = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        do {
            guard let data = UserDefaults.standard.value(forKey: "Moire") as? Data else {throw NSError()}
            self.moires.append(try PropertyListDecoder().decode(Moire.self, from: data))
        } catch {
            print("problem loading saved moire; loading the default")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
        return self.moires.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveFileCell", for: indexPath) as! SaveFileCollectionViewCell
        if indexPath.row < self.moires.count {
            let m = self.moires[indexPath.row]
            cell.setUp(previewImage: m.preview)
        } else {
            cell.setUp(previewImage: UIImage(systemName: "plus.rectangle")!)
        }
        return cell
    }
}
