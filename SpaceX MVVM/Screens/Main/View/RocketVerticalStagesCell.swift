//
//  RocketVerticalFirstStageCell.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

final class RocketVerticalStagesCell: UICollectionViewCell {

    private let leftLabel = UILabel()
    private let valueLabel = UILabel()
    private let measureLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setLeftLabel()
        setValueLabel()
        setMeasureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCell(model: RocketCellItem) {
        leftLabel.text = model.title ?? "n/a"
        valueLabel.text = model.value ?? "n/a"
        measureLabel.text = model.measure ?? "n/a"
    }

    private func setView() {
        contentView.backgroundColor = .black
        contentView.addSubview(leftLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(measureLabel)
    }

    private func setLeftLabel() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: globalMargins).isActive = true
        leftLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -10).isActive = true
        leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        leftLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        leftLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftLabel.textColor = .white
    }

    private func setValueLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.rightAnchor.constraint(equalTo: measureLabel.leftAnchor, constant: -10).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.textColor = .white
    }

    private func setMeasureLabel() {
        measureLabel.translatesAutoresizingMaskIntoConstraints = false
        measureLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -globalMargins).isActive = true
        measureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        measureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        measureLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        measureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        measureLabel.textColor = .white
    }
}
