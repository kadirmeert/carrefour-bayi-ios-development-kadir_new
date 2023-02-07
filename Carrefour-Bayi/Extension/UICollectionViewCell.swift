//
//  UICollectionViewCell.swift
//  Carrefour-Bayi
//
//  Created by Cemre Öncel on 23.08.2022.
//

import UIKit

extension UICollectionViewCell {
    class func registerSelf(collectionView: UICollectionView) {
        let nib = UINib(nibName: self.className, bundle: Bundle(for: self))
        collectionView.register(nib, forCellWithReuseIdentifier: self.className)
    }
}
