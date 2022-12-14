//
//  TopCell.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/6/22.
//

import UIKit

class CellForTop: UICollectionViewCell {
    var imageView: UIImageView!
    var bottomView: UIView!
    weak var delegate: MainRocketVCProtocol?
    var titleLabel: UILabel! {
        didSet {
            updateTitleLabelSize()
        }
    }
    var navVC: UINavigationController?
    var settingsButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        setContentView()
        createImage()
        createBottomView()
        createTitleLabel()
        createSettingsButton()
    }
    func setContentView() {
        contentView.backgroundColor = .black
    }
    
    func createImage() {
        let image = UIImage(named: "BackgroundPic")
        imageView = UIImageView(frame: contentView.frame)
        imageView.image = image
        imageView.clipsToBounds = true
        imageView.contentMode = .top
        
        contentView.addSubview(imageView)
    }
    func createBottomView() {
        let height: CGFloat = 70
        let yPos = contentView.frame.height - height
        let width = UIScreen.main.bounds.width
        bottomView = UIView(frame: CGRect(x: 0, y: yPos, width: width, height: height))
        bottomView.backgroundColor = .black
        bottomView.layer.cornerRadius = 25
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.addSubview(bottomView)
    }
    func createTitleLabel() {
        titleLabel = UILabel(frame: CGRect(x: globalMargins, y: 35, width: 0, height: 30))
        bottomView.addSubview(titleLabel)
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "GillSans-SemiBold", size: 24)
        titleLabel.text = "Loading...       "
        updateTitleLabelSize()
    }
    func updateTitleLabelSize() {
        updateLabelWidth(label: titleLabel)
    }
    func createSettingsButton() {
        settingsButton = UIButton()
        let image = UIImage(named: "Setting")
        settingsButton.setBackgroundImage(image, for: .normal)
        settingsButton.frame.size.width = 32
        settingsButton.frame.size.height = 32
        settingsButton.frame.origin.y = titleLabel.frame.origin.y
        settingsButton.frame.origin.x = UIScreen.main.bounds.width - globalMargins - settingsButton.frame.size.width
        bottomView.addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
    }
    @objc func settingsButtonAction() {
        let settingsVC = SettingsVC()
        settingsVC.delegate = delegate
        navVC?.present(settingsVC, animated: true)
        
    }
}
