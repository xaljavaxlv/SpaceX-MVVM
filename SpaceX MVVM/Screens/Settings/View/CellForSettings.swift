//
//  CellForSettings.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/7/22.
//

import UIKit

class CellForSettings: UITableViewCell {
    
    weak var viewController: MainRocketVCProtocol!
    var segmentControl: UISegmentedControl!
    var leftLabel: UILabel!
    var ftM = ["ft", "m"]
    var lbKg = ["lb", "kg"]
    var dimension: SettingsKeys? {
        didSet {
            updateLeftLabel()
            updateSegmentControlTitles()
            contentView.backgroundColor = .black
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createLeftLabel()
        createSegmentControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLeftLabel() {
        let height: CGFloat = 20
        let width: CGFloat = 200
        let cellCenter = contentView.frame.height / 2
        let yPos = cellCenter - height / 2
        leftLabel = UILabel(frame: CGRect(x: globalMargins, y: yPos, width: width, height: height))
        contentView.addSubview(leftLabel)
        leftLabel.textColor = .white
        leftLabel.text = "..."
    }
    func createSegmentControl() {
        let height: CGFloat = 40
        let width: CGFloat = 140
        let cellCenter = contentView.frame.height / 2
        let yPos = cellCenter - height / 2
        let xPos = UIScreen.main.bounds.width - globalMargins - width
        segmentControl = UISegmentedControl(items: ["", ""])
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        segmentControl.frame = frame
        segmentControl.backgroundColor = #colorLiteral(red: 0.03326117247, green: 0.03340944275, blue: 0.03379229829, alpha: 1)
        contentView.addSubview(segmentControl)
        segmentControl.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
    }
    @objc func segmentControlAction() {
        guard let dimension = dimension else { return }
        let index = segmentControl.selectedSegmentIndex
        switch dimension {
        case .height:
            if index == 0 {
                UserSettings.shared.setHeight(new: .feets)
            } else {
                UserSettings.shared.setHeight(new: .meters)
            }
            
        case .diameter:
            if index == 0 {
                UserSettings.shared.setDiameter(new: .feets)
            } else {
                UserSettings.shared.setDiameter(new: .meters)
            }
        case .mass:
            if index == 0 {
                UserSettings.shared.setMass(new: .lb)
            } else {
                UserSettings.shared.setMass(new: .kg)
            }
        case .payload:
            if index == 0 {
                UserSettings.shared.setPayoad(new: .lb)
            } else {
                UserSettings.shared.setPayoad(new: .kg)
            }
        }
        
        viewController.updateSavedSettings()//.reload()
    }
    
    func updateLeftLabel() {
        guard let dimension = dimension else { return }
        switch dimension {
        case .height: leftLabel.text = "Height"
        case .diameter:  leftLabel.text = "Diameter"
        case .mass:  leftLabel.text = "Mass"
        case .payload:  leftLabel.text = "Payload"
        }
    }
    func updateSegmentControlTitles() {
        if dimension == .height || dimension == .diameter {
            segmentControl.setTitle(ftM[0], forSegmentAt: 0)
            segmentControl.setTitle(ftM[1], forSegmentAt: 1)
        } else {
            segmentControl.setTitle(lbKg[0], forSegmentAt: 0)
            segmentControl.setTitle(lbKg[1], forSegmentAt: 1)
        }
        updateSegmentControlPosition()
    }
    func updateSegmentControlPosition() {
        guard let dimension = dimension else { return }
        switch dimension {
        case .height:

            if UserSettings.shared.getHeight() == Lenghts.feets.rawValue {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
        case .diameter:
            if UserSettings.shared.getDiameter() == Lenghts.feets.rawValue {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
        case .mass:
            if UserSettings.shared.getMass() == Weights.lb.rawValue {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
        case .payload:
            if UserSettings.shared.getPayload() == Weights.lb.rawValue {
                segmentControl.selectedSegmentIndex = 0
            } else {
                segmentControl.selectedSegmentIndex = 1
            }
        }

        
    }
}

