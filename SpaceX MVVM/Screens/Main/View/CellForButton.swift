//
//  CellForButton.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import UIKit

class CellForButton: UICollectionViewCell {
    
    var button: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createButton() {
        button = UIButton(frame: contentView.frame)
        button.layer.cornerRadius = 15
        button.backgroundColor = #colorLiteral(red: 0.07739504427, green: 0.07739504427, blue: 0.07739504427, alpha: 1)
        button.setTitle("See Launches", for: .normal)
        contentView.addSubview(button)
    }

}
