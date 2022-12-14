//
//  CellForHorizontalItem.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import UIKit

class CellForHorizontalItem: UICollectionViewCell {
    
    var stackView: UIStackView!
    var topLabel: UILabel!
    var bottomLabel: UILabel!
    var model: StringsModel? {
        didSet {
            updateLabelsText()
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
        createStackView()
        createTopLabel()
        createBottomLabel()
    }
    func setView() {
        contentView.backgroundColor = #colorLiteral(red: 0.03326117247, green: 0.03340944275, blue: 0.03379229829, alpha: 1)
        contentView.layer.cornerRadius = 35
    }
    
    func createStackView() {
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.center = contentView.center
        stackView.frame.size.width = contentView.frame.width
        stackView.frame.size.height = 50
        

        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.center = contentView.center
        stackView.distribution = .equalCentering
        stackView.alignment = .center
    }
    func createTopLabel() {
        topLabel = UILabel()
        stackView.addArrangedSubview(topLabel)
        topLabel.textColor = .white
        let center = stackView.frame.width / 2
        topLabel.frame.origin.x = center - topLabel.frame.origin.x / 2
        topLabel.text = "..."
        topLabel.frame.size.height = 10
        updateTopLabel()
    }
    func createBottomLabel() {
        bottomLabel = UILabel()
        stackView.addArrangedSubview(bottomLabel)
        bottomLabel.textColor = .white
        let center = stackView.frame.width / 2
        bottomLabel.frame.origin.x = center - bottomLabel.frame.origin.x / 2
        bottomLabel.text = "..."
        bottomLabel.frame.size.height = 10
        updateBottomLabel()
    }
    func updateLabelsSizes() {
        updateTopLabel()
        updateBottomLabel()
    }
    func updateTopLabel() {
        guard let toplabel = topLabel else { return }
        updateLabelWidth(label: toplabel)
    }
    func updateBottomLabel() {
        guard let bottomLabel = bottomLabel else { return }
        updateLabelWidth(label: bottomLabel)
    }
    func updateLabelsText() {
        guard let model = model else { return }
        topLabel.text = model.value ?? "n/a"
        bottomLabel.text = model.tittle ?? "n/a"
    }
}
