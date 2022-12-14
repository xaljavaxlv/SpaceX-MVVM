//
//  CellForLaunches.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import UIKit

class CellForLaunches: UITableViewCell {
    
    var view: UIView!
    var topLabel: UILabel!
    var bottomLabel: UILabel!
    var imgView: UIImageView!
    var model: LaunchesModel! {
        didSet {
            setlabels()
            setImage()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setTopLabel()
        setBottomLabel()
        setImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setView() {
        contentView.backgroundColor = .black
        view = UIView()
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: globalMargins).isActive = true
        view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -globalMargins).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        view.backgroundColor = #colorLiteral(red: 0.1494633555, green: 0.1494633555, blue: 0.1494633555, alpha: 1)
        view.layer.cornerRadius = 20
        
    }
    func setTopLabel() {
        topLabel = UILabel(frame: CGRect(x: globalMargins, y: 10, width: 250, height: 20))
        view.addSubview(topLabel)
        topLabel.textColor = .white
    }
    func setBottomLabel() {
        let width: CGFloat = 250
        let yPos: CGFloat = topLabel.frame.height + topLabel.frame.origin.y + 15
        bottomLabel = UILabel(frame: CGRect(x: globalMargins, y: yPos, width: width, height: 20))
        view.addSubview(bottomLabel)
        bottomLabel.textColor = .white
    }
    func setImageView() {
        let width: CGFloat = 30
        let xPos: CGFloat = contentView.frame.size.width - globalMargins - width
        let center = topLabel.frame.height + topLabel.frame.origin.y + 7
        let yPos: CGFloat = center - width / 2
        imgView = UIImageView(frame: CGRect(x: xPos, y: yPos, width: width, height: width))
        view.addSubview(imgView)
    }
    func setImage() {
        var img = UIImage()
        guard let state = model.success else { return }
        if state {
            img = UIImage(named: "rocketup")!
        } else {
            img = UIImage(named: "rocketdown")!
        }
        imgView.image = img
    }
    func setlabels() {
        topLabel.text = model.name
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        guard let date = model.dateLocal else { return }
        formatter1.dateFormat = "d MMM y"
        let dateString = formatter1.string(from: date)
        bottomLabel.text = "\(dateString)"
    }
}
