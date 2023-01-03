//
//  TopCell.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

final class RocketHeaderCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let bottomView = UIView()
    let titleLabel = UILabel()
    private let settingsButton = UIButton()
    weak var delegate: RocketVCProtocol!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCell(title: String, delegate: RocketVCProtocol) {
        titleLabel.text = title
        self.delegate = delegate
    }

    private func setCellViews() {
        setContentView()
        setImage()
        setBottomView()
        setTitleLabel()
        setSettingsButton()
    }

    private func setContentView() {
        contentView.backgroundColor = .black
        contentView.addSubview(imageView)
        contentView.addSubview(bottomView)

    }

    private func setImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        let image = UIImage(named: "BackgroundPic")
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .top
    }

    private func setBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        bottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        bottomView.backgroundColor = .black
        bottomView.layer.cornerRadius = 25
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(settingsButton)
    }

    private func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor,
                                         constant: Constants.globalMargins).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: settingsButton.leftAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 35).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "GillSans-SemiBold", size: 24)
    }

    private func setSettingsButton() {
        let image = UIImage(named: "Setting")
        settingsButton.setBackgroundImage(image, for: .normal)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor,
                                              constant: -Constants.globalMargins).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
    }

    @objc private func settingsButtonAction() {
        guard let delegate = delegate else { return }
        let settingsVC = SettingsVC(viewModel: SettingsViewModel())
        settingsVC.delegate = delegate
        let settingsNavContr = UINavigationController(rootViewController: settingsVC)
        delegate.navigationController?.present(settingsNavContr, animated: true)
    }
}
