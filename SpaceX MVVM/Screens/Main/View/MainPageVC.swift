//
//  MainPageVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

protocol MainPageVCProtocol: AnyObject {
    func getRocketData(rockets: [RocketModel])
    func reloadAllVC()
}

final class MainPageVC: UIPageViewController {

    private var rocketViewControllers = [RocketVC]()
    private let dataProvider = RocketDataProvider()
    private var rockets: [RocketModel]? {
        didSet {
            createRocketVCList()
            setViewControllers([rocketViewControllers[0]], direction: .forward, animated: true)
            spinner.stopAnimating()
        }
    }
    private var spinner = UIActivityIndicatorView(style: .large)

    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
        setDataProvider()
        self.view.backgroundColor = #colorLiteral(red: 0.08059107512, green: 0.08059107512, blue: 0.08059107512, alpha: 1)
        startSpinner()
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func startSpinner() {
        spinner.frame.size.height = 50
        spinner.frame.size.width = 50
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }

    private func setDataProvider() {
        dataProvider.fetchRockets { [weak self] rockets in
            guard let self = self else { return }
            self.rockets = rockets
        }
    }

    private func createRocketVCList() {
        guard let rockets = rockets else { return }
        for rocket in rockets {
            let rocketViewModel = RocketViewModel(rocket: rocket)
            let newRocketVC = RocketVC(viewModel: rocketViewModel)
            newRocketVC.mainPageVC = self
            rocketViewControllers.append(newRocketVC)
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension MainPageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketVC else { return nil }
        guard let  index = rocketViewControllers.firstIndex(of: viewController) else { return UIViewController() }
        if index > 0 {
            return rocketViewControllers[index - 1]
        }
        return UIViewController()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketVC else { return nil }
        guard let  index = rocketViewControllers.firstIndex(of: viewController) else { return UIViewController() }
        guard let rockets = rockets else { return nil}
        if index < rockets.count - 1 {
            return rocketViewControllers[index + 1]
        }
        return UIViewController()
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard let rockets = rockets else { return 0}
        return rockets.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}

// MARK: - Conforming MainPageVCProtocol

extension MainPageVC: MainPageVCProtocol {

    func getRocketData(rockets: [RocketModel]) {
        self.rockets = rockets
    }

    func reloadAllVC() {
        rocketViewControllers.forEach({$0.reloadItems()})
    }
}
