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
        print("SDSD")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHeader() {
//        title.translatesAutoresizingMaskIntoConstraints = false
//        title.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
//        title.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
//        title.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: height).isActive = true
//        title.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true

        //imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //imgView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        //imgView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        title.text = "Stage N"
        title.textColor = .white

    }
}

// NSCollectionLayoutBoundarySupplementaryItem
