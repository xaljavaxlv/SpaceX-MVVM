//
//  SettingsVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/24/22.
//

import UIKit

protocol SettingsVCProtocol: AnyObject {
    func updateSavedSettings(segmentIndex: Int, dimension: DimensionsKeys)
}

final class SettingsVC: UIViewController {

    private let tableView = UITableView()
    weak var delegate: RocketVCProtocol?
    private let viewModel: SettingsViewModelProtocol

    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
    }
}

// MARK: - UITableViewDataSource

extension SettingsVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settingsCellItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier) as? SettingsCell
        else { return UITableViewCell() }
        let model = viewModel.settingsCellItems[indexPath.row]
        cell.updateStrings(model: model, viewController: self)
        return cell
    }
}

// MARK: - Conforming SettingsVCProtocol

extension SettingsVC: SettingsVCProtocol {
    func updateSavedSettings(segmentIndex: Int, dimension: DimensionsKeys) {
        viewModel.saveNewSettings(segmentIndex: segmentIndex, dimension: dimension)
        delegate?.reloadItems()
    }
}

// MARK: - SETUP UI
private extension SettingsVC {
     func setScreen() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        setNavigationItems()
        createTableView()
        registerCell()
    }

     func setNavigationItems() {
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(closeButtonAction))
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .highlighted)
    }

    @objc  func closeButtonAction() {
        self.dismiss(animated: true)
    }

     func createTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
    }

     func registerCell() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
    }
}
