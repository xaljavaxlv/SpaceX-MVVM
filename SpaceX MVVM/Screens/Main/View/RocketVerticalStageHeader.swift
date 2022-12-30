//
//  RocketVerticalStageHeader.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/26/22.
//

import UIKit

class RocketVerticalStageHeader: UICollectionReusableView {

    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setHeader()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHeader() {
        title.text = "Stage N"
        title.textColor = .white

    }
}
