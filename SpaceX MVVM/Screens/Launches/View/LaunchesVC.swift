//
//  LaunchesVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/11/22.
//

import UIKit

protocol LaunchesVCProtocol: AnyObject {
    func reload()
}
extension LaunchesVC: LaunchesVCProtocol {
    func reload() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
}

class LaunchesVC: UIViewController {
    
    var tableView: UITableView!
    var viewModel: LaunchesVCViewModelProtocol!
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        registerCells()
        startSpinner()
        setTitle()
    }
    func createTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        tableView.separatorColor = .clear
    }
    func registerCells() {
        tableView.register(CellForLaunches.self, forCellReuseIdentifier: "CellForLaunches")
    }
    func startSpinner() {
        spinner.frame.size.height = 50
        spinner.frame.size.width = 50
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    func setTitle() {
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

}


extension LaunchesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let launches = viewModel.launchesForRocket else { return 0 }
        return launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForLaunches") as? CellForLaunches
        guard let launches = viewModel.launchesForRocket else { return cell!}
        let launch = launches[indexPath.row]
        cell?.model = launch
        return cell!
    }
    
    
}


extension LaunchesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
