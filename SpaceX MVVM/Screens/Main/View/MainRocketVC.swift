//
//  ViewController.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/5/22.
//

import UIKit

protocol MainRocketVCProtocol: AnyObject {
    var mainPageVC: MainPageVCProtocol? { get set }
    func reload()
    func updateSavedSettings()
}

extension MainRocketVC: MainRocketVCProtocol {
    func updateSavedSettings() {
        mainPageVC?.reloadAllVC()
    }
    
    func reload() {
        viewModel.updateTitles()
        collectionView.reloadData()
    }
}

class MainRocketVC: UIViewController {
    
    var collectionView: UICollectionView!
    weak var mainPageVC: MainPageVCProtocol?
    var viewModel: MainRocketViewModelProtocol!
    init(rocket: RocketModel) {
        super.init(nibName: nil, bundle: nil)
        setupScreen()
        viewModel = MainRocketViewModel(viewController: self, rocket: rocket)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupScreen() {
        createCollectionView()
        self.navigationController?.view.backgroundColor = .white
    }
    func createCollectionView() {
        let collectionViewLayout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        
            // TODO: - -70 это правильно? Навигейшн белый при скроле
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -70).isActive = true //
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionView.bounces = false // не уверен - проверить что это вообще такое
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        registerCells()
        
    }

    
    func registerCells() {
        self.collectionView.register(CellForTop.self, forCellWithReuseIdentifier: "CellForTop")
        self.collectionView.register(CellForVerticalItem.self, forCellWithReuseIdentifier: "CellForVerticalItem")
        self.collectionView.register(CellForHorizontalItem.self, forCellWithReuseIdentifier: "CellForHorizontalItem")
        self.collectionView.register(CellForButton.self, forCellWithReuseIdentifier: "CellForButton")
    }


}


extension MainRocketVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0: return 1
        case 1: return viewModel.numberOfItemsForHorizontal
        case 2: return viewModel.numberOfItemsForVertical
        case 3: return 1
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: return createCellForTop(indexPath: indexPath)
        case 1: return createCellForHorizontalItems(indexPath: indexPath)
        case 2: return createCellForVerticalItems(indexPath: indexPath)
        case 3: return createCellForButton(indexPath: indexPath)
        default: return createCellForTop(indexPath: indexPath)
        }
    }
    // TODO: - nav VC - сделает ретейн сайкл? Узнать у Антона
    func createCellForTop(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForTop",
                                                      for: indexPath) as? CellForTop
        cell?.titleLabel.text = viewModel.titleRocket
        cell?.navVC = self.navigationController // ретейн или нет?
        cell?.delegate = self// cell -> SettingsVC -> cell- так ок?
        return cell!
    }
    
    func createCellForHorizontalItems(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForHorizontalItem",
                                                      for: indexPath) as? CellForHorizontalItem
        
        let model = viewModel.horizontalValues
        if model.count > 0 {
            cell?.model = model[indexPath.row]
        }
        return cell!
    }
    
    func createCellForVerticalItems(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForVerticalItem",
                                                      for: indexPath) as? CellForVerticalItem
        let model = viewModel.verticalValues
        if model.count > 0 {
            cell?.model = model[indexPath.row]
        }
        return cell!
    }
    func createCellForButton(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForButton",
                                                      for: indexPath) as? CellForButton
        cell!.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return cell!
    }
    @objc func buttonAction() {
        let launchesVC = LaunchesVC()
        let viewModel = LaunchesVCViewModel(viewController: launchesVC, rocketId: viewModel.rocketId())
        launchesVC.viewModel = viewModel
        launchesVC.title = self.viewModel.titleRocket
        navigationController?.pushViewController(launchesVC, animated: true)
    }
    
    // MARK: - CollectionView Sections and CompositionalLayout
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _  in
           guard let self = self else { return nil }
            switch sectionIndex  {
            case 0: return self.createTopSection()
            case 1: return self.createHorizontalScrollSection()
            case 2: return self.createVerticalTableSection()
            case 3: return self.createButtonSection()
            default: return self.createHorizontalScrollSection()
            }
        }
    }
    
    func createTopSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(width)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(width)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let margins: CGFloat = 10
        let countOfCells: CGFloat = 3
        let allMargins = (countOfCells + 1) * margins
        let withForCell: CGFloat = (width - allMargins) / 3
        let widthForSection = 7 * withForCell + 8 * margins
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(withForCell), heightDimension: .absolute(withForCell)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(widthForSection), heightDimension: .absolute(withForCell)), subitems: [item])
        group.interItemSpacing = .fixed(margins)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 20, leading: margins, bottom: 0, trailing: 0)
        return section
    }
    func createVerticalTableSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let margins: CGFloat = 10
        let countOfCells: CGFloat = 9
        let allMargins = countOfCells * margins
        let heightForCell: CGFloat = 30 // нужно знать как делать динамическую высоту для разных ячеек
        let heightForSection = heightForCell * countOfCells + allMargins
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(heightForCell)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(heightForSection)), subitems: [item])
        group.interItemSpacing = .fixed(margins)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    func createButtonSection() -> NSCollectionLayoutSection {
        let height: CGFloat = 50
        let width: CGFloat = UIScreen.main.bounds.width - globalMargins * 2
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(height)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: globalMargins, bottom: 20, trailing: 0)
        return section
    }
    
}

