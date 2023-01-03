//
//  CellForSettings.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import UIKit

final class SettingsCell: UITableViewCell {

    private weak var viewController: SettingsVCProtocol?
    private let segmentControl = UISegmentedControl()
    private let leftLabel = UILabel()
    private var dimension: DimensionsKeys?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(leftLabel)
        contentView.addSubview(segmentControl)
        createSegmentControl()
        createLeftLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateStrings(model: SettingsCellItem, viewController: SettingsVCProtocol) {
        self.viewController = viewController
        leftLabel.text = model.dimension.rawValue.capitalized
        segmentControl.insertSegment(withTitle: model.segmentLeftTitle, at: 0, animated: true)
        segmentControl.insertSegment(withTitle: model.segmentRightLabel, at: 1, animated: true)
        segmentControl.selectedSegmentIndex = model.segmentIndex
        dimension = model.dimension
    }

    private func createLeftLabel() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        leftLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                        constant: Constants.globalMargins).isActive = true
        leftLabel.rightAnchor.constraint(equalTo: segmentControl.leftAnchor, constant: -10).isActive = true
        leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftLabel.textColor = .white

    }

    private func createSegmentControl() {
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                              constant: -Constants.globalMargins).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: 140).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        segmentControl.backgroundColor = #colorLiteral(red: 0.2511570454, green: 0.2551486194, blue: 0.2578211129, alpha: 1)
        segmentControl.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
    }

    @objc private func segmentControlAction() {
        guard let dimension = dimension, let viewController = viewController else { return }
        let index = segmentControl.selectedSegmentIndex
        viewController.updateSavedSettings(segmentIndex: index, dimension: dimension)
    }
}
