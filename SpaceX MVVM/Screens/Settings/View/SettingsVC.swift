//
//  SettingsVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/7/22.
//

import UIKit

class SettingsVC: UIViewController {
    
    var topView: UIView!
    var tableView: UITableView!
    weak var delegate: MainRocketVCProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setScreen()
        
    }
    func setScreen() {
        createTopView()
        createTableView()
        registerCell()
    }
    func createTopView() {
        let width = view.frame.size.width
        let height: CGFloat = 70
        topView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.addSubview(topView)
        topView.backgroundColor = .black
        createTitleLabel()
        createCloseButton()
    }
    func createTitleLabel() {
        let label = UILabel()
        topView.addSubview(label)
        label.text = "Settings"
        label.textColor = .white
        updateLabelWidth(label: label)
        label.frame.size.height = 20
        let yPos: CGFloat = 0
        let center = topView.frame.width / 2
        let xPos = center - label.frame.width / 2
        label.frame.origin.x = xPos
        label.frame.origin.y = yPos
    }
    func createCloseButton() {
        let button = UIButton()
        let height: CGFloat = 20
        let width: CGFloat = 50
        let yPos: CGFloat = 0
        let xPos = topView.frame.width - globalMargins - width
        let frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        button.frame = frame
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        topView.addSubview(button)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
    @objc func closeButtonAction() {
        self.dismiss(animated: true)
    }
    func createTableView() {
        let yPos: CGFloat = topView.frame.origin.y + topView.frame.height
        let xPos: CGFloat = 0
        let width = view.frame.width
        let height = view.frame.height + 100
        tableView = UITableView(frame: CGRect(x: xPos, y: yPos, width: width, height: height))
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .black
    }

    func registerCell() {
        tableView.register(CellForSettings.self, forCellReuseIdentifier: "CellForSettings")
    }
    
}

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        topView.frame.height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return topView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsKeys.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSettings") as? CellForSettings
        cell?.dimension = SettingsKeys.allCases[indexPath.row]
        cell?.viewController = delegate
        return cell!
    }
    
    
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
