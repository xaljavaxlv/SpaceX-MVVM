//
//  CellForCollectionView.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/5/22.
//

import UIKit

class CellForVerticalItem: UICollectionViewCell {
    
    var leftLabel: UILabel!
    var valueLabel: UILabel!
    var model: StringsModel? {
        didSet {
            updateLabelsText()
            updateAllLabelsSizeAndPosition()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setCell() {
        setView()
        createLeftLabel()
        createRightLabel()
    }
    func setView() {
        contentView.backgroundColor = .black
        
    }

    func createLeftLabel() {
        leftLabel = UILabel(frame: CGRect(x: globalMargins, y: 10, width: 0, height: 20)) // width updates below
        contentView.addSubview(leftLabel!)
        leftLabel!.textColor = .white
        leftLabel!.text = "..."
        updateLeftLabel()
    }
    func createRightLabel() {
        valueLabel = UILabel(frame: CGRect(x: 0, y: 10, width: 0, height: 20))  // x and width updates below
        contentView.addSubview(valueLabel!)
        valueLabel!.textColor = .white
        valueLabel!.text = "..."
        updateRightLabel()
    }
    func updateAllLabelsSizeAndPosition() {
        updateLeftLabel()
        updateRightLabel()
    }
    func updateLeftLabel() {
        guard let leftLabel = leftLabel else { return }
        updateLabelWidth(label: leftLabel)
    }
    func updateRightLabel() {
        guard let rightLabel = valueLabel else { return }
        updateLabelWidth(label: rightLabel)
//        let xPos = contentView.frame.size.width - rightLabel.frame.size.width // почему-то работает неправильно
        let xPos = UIScreen.main.bounds.width - globalMargins - rightLabel.frame.size.width
        rightLabel.frame.origin.x = xPos
    }
    func updateLabelsText() {
        guard let model = model else { return }
        leftLabel.text = model.tittle ?? "n/a"
        valueLabel.text = model.value ?? "n/a"
        
    }
}
