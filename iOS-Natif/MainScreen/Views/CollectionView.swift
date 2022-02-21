//
//  CollectionView.swift
//  iOS-Natif
//
//  Created by Earth on 20.02.2022.
//

import UIKit

class CollectionView: UICollectionView {

    func registerNib() {
        let nib = UINib(nibName: "CollectionCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "CollectionCell")
    }
    
    func getСonfiguredCell(for indexPath: IndexPath) -> CollectionCell {
        dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
    }
    
}
