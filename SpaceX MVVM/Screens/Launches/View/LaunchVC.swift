//
//  LaunchesVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import UIKit

protocol LaunchVCProtocol: AnyObject {
    func reload()
}


final class LaunchVC: UIViewController {
    
    private let tableView = UITableView()
    private var viewModel: LaunchVCViewModelProtocol!
    private let spinner = UIActivityIndicatorView(style: .large)
    
    init(viewModel: LaunchVCViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        registerCells()
        startSpinner()
        setTitle()
    }
    private func createTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .clear
    }
    private func registerCells() {
        tableView.register(LaunchCell.self, forCellReuseIdentifier: "CellForLaunches")
    }
    private  func startSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        spinner.startAnimating()
    }
    private func setTitle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}

extension LaunchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.launchStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForLaunches") as? LaunchCell
        guard let cell = cell else { return UITableViewCell() }
        let launchStrings = viewModel.launchStrings
        cell.updateContent(model: launchStrings[indexPath.row])
        return cell
    }
}

extension LaunchVC: LaunchVCProtocol {
    func reload() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
}
