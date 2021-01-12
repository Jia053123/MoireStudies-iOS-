//
//  SaveFilesViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFilesViewController: UICollectionViewController {
    var moires: Array<MoireModel> = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        do {
            guard let data = UserDefaults.standard.value(forKey: "Moire") as? Data else {throw NSError()}
            self.moires.append(try PropertyListDecoder().decode(MoireModel.self, from: data))
        } catch {
            print("problem loading saved moire; loading the default")
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moires.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let m = self.moires[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "saveFileCell", for: indexPath) as! SaveFileCollectionViewCell
        cell.setUp(previewImage: m.preview)
        return cell
    }
}
