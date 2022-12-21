//
//  CellForHorizontalItem.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import UIKit

final class RocketHorizontalItemCell: UICollectionViewCell {

    private let topLabel = UILabel()
    private let bottomLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setCell() {
        setView()
        createTopLabel()
        createBottomLabel()
    }

    private func setView() {
        contentView.backgroundColor = #colorLiteral(red: 0.03326117247, green: 0.03340944275, blue: 0.03379229829, alpha: 1)
        contentView.layer.cornerRadius = 35
        contentView.addSubview(topLabel)
        contentView.addSubview(bottomLabel)
    }

    // якори ведут себя непредсказуемо, скорее всего потому что высота ячейки задана принудительно
    private func createTopLabel() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        topLabel.bottomAnchor.constraint(equalTo: bottomLabel.topAnchor, constant: 0).isActive = true
        topLabel.textColor = .white
    }

    private func createBottomLabel() {
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        bottomLabel.textColor = .white
    }

    public func updateLabelsText(model: StringsRocketModel) {
        topLabel.text = model.value ?? "n/a"
        bottomLabel.text = model.tittle ?? "n/a"
    }
}
