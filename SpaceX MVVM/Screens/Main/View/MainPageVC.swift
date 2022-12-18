//
//  MainPageVC.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/10/22.
//

import UIKit

protocol MainPageVCProtocol: AnyObject {
    func getRocketData(rockets: [RocketModel])
    func reloadAllVC()
}
extension MainPageVC: MainPageVCProtocol {
    func getRocketData(rockets: [RocketModel]) {
        self.rockets = rockets
    }
    func reloadAllVC() {
        for rocketVC in rocketViewControllers {
            rocketVC.reload()
        }
    }
}

final class MainPageVC: UIPageViewController {
    
    private var rocketViewControllers = [RocketVC]() // хотел сделать через протокол но в методах датасорса не находит
    private var dataProvider: RocketDataProvider!
    private var rockets: [RocketModel]? {
        didSet {
            createRocketVCList()
            setViewControllers([rocketViewControllers[0]], direction: .forward, animated: true)
            spinner.stopAnimating()
        }
    }
    private var spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.08059107512, green: 0.08059107512, blue: 0.08059107512, alpha: 1)
        startSpinner()
    }
    
    
    private func startSpinner() {
        spinner.frame.size.height = 50
        spinner.frame.size.width = 50
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    private func setDataProvider() {
        dataProvider = RocketDataProvider()
        dataProvider.delegate = self
    }
    
    private func createRocketVCList() {
        guard let rockets = rockets else { return }
        for rocket in rockets {
            let newRocketVC = RocketVC(rocket: rocket)
            newRocketVC.mainPageVC = self
            rocketViewControllers.append(newRocketVC)
        }
    }

    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
        setDataProvider()
        self.view.backgroundColor = #colorLiteral(red: 0.08059107512, green: 0.08059107512, blue: 0.08059107512, alpha: 1)
        self.dataSource = self
        self.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainPageVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketVC else { return nil }
        if let  index = rocketViewControllers.firstIndex(of: viewController) {
            if index > 0 {
                return rocketViewControllers[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? RocketVC else { return nil }
        if let  index = rocketViewControllers.firstIndex(of: viewController) {
           guard let rockets = rockets else { return nil}
            if index < rockets.count - 1 {
                return rocketViewControllers[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard let rockets = rockets else { return 0}
        return rockets.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
}
