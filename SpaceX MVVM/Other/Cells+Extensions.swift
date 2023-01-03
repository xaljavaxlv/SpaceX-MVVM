//
//  UICollectionView+Extension.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 1/2/23.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell {
    static  var identifier: String {
        String(describing: Self.self)
    }
}
