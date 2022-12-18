//
//  SettingsVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/7/22.
//

import UIKit

protocol SettingsVCProtocol: AnyObject {
    func updateSavedSettings(segmentIndex: Int, dimension: DimensionsKeys)
}

extension SettingsVC: SettingsVCProtocol {
    func updateSavedSettings(segmentIndex: Int, dimension: DimensionsKeys) {
        viewModel.saveNewSettings(segmentIndex: segmentIndex, dimension: dimension)
        guard let delegate = delegate else { return }
        delegate.reload()
    }
    
    
}

final class SettingsVC: UIViewController {
    
    private var tableView = UITableView()
    private weak var delegate: RocketVCProtocol?
    private var viewModel: SettingsViewModelProtocol!
    
    init(viewModel: SettingsViewModelProtocol, delegate: RocketVCProtocol) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreen()
    }
    
    private func setScreen() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        setNavigationItems()
        createTableView()
        registerCell()
    }
    
    private func setNavigationItems() {
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeButtonAction))
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .selected)
    }
    
    @objc private func closeButtonAction() {
        self.dismiss(animated: true)
    }
    
    private func createTableView() {
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
    
    private func registerCell() {
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "CellForSettings")
    }
    
}

extension SettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.settingsStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSettings") as? SettingsCell
        guard let cell = cell else { return UITableViewCell() }
        let model = viewModel.settingsStrings[indexPath.row]
        cell.updateStrings(model: model, viewController: self)
//        cell?.dimension = SettingsKeys.allCases[indexPath.row]
//        cell?.viewController = delegate
        return cell
    }
}


