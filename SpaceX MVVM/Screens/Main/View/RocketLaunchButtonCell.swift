//
//  CellForButton.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

final class RocketLaunchButtonCell: UICollectionViewCell {

    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createButton() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        button.layer.cornerRadius = 15
        button.backgroundColor = #colorLiteral(red: 0.07739504427, green: 0.07739504427, blue: 0.07739504427, alpha: 1)
        button.setTitle("See Launches", for: .normal)
    }
}
