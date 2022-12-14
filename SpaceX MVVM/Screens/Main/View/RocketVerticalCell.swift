//
//  CellForCollectionView.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

final class RocketVerticalCell: UICollectionViewCell {

    private let leftLabel = UILabel()
    private let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setLeftLabel()
        setRightLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCell(model: RocketCellItem) {
        leftLabel.text = model.title
        valueLabel.text = model.value
    }

    private func setView() {
        contentView.backgroundColor = .black
        contentView.addSubview(leftLabel)
        contentView.addSubview(valueLabel)
    }

    private func setLeftLabel() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                        constant: Constants.globalMargins).isActive = true
        leftLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -10).isActive = true
        leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftLabel.textColor = .white
    }

    private func setRightLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                          constant: -Constants.globalMargins).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.textColor = .white
    }
}
