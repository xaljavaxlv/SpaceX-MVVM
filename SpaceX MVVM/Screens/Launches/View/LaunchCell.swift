//
//  CellForLaunches.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import UIKit

class LaunchCell: UITableViewCell {

    private let view = UIView()
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    private let imgView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setImageView()
        setTopLabel()
        setBottomLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateContent(model: LaunchCellItem) {
        topLabel.text = model.name
        bottomLabel.text = model.date
        imgView.image = UIImage(named: model.imageName.rawValue)
    }

    private func setView() {
        contentView.backgroundColor = .black
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: globalMargins).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -globalMargins).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        view.backgroundColor = #colorLiteral(red: 0.1494633555, green: 0.1494633555, blue: 0.1494633555, alpha: 1)
        view.layer.cornerRadius = 20
    }

    private func setImageView() {
        view.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -globalMargins).isActive = true
        imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    private func setTopLabel() {
        view.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        topLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: globalMargins).isActive = true
        topLabel.rightAnchor.constraint(equalTo: imgView.leftAnchor, constant: 10).isActive = true
        topLabel.textColor = .white
    }

    private func setBottomLabel() {
        view.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10).isActive = true
        bottomLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: globalMargins).isActive = true
        bottomLabel.rightAnchor.constraint(equalTo: imgView.leftAnchor, constant: 10).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        bottomLabel.textColor = .white
    }
}
