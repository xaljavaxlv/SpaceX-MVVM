//
//  ViewController.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/5/22.
//

import UIKit

protocol RocketVCProtocol: AnyObject {
    var mainPageVC: MainPageVCProtocol? { get set }
    func reload()
    func updateSavedSettings()
}

extension RocketVC: RocketVCProtocol {
    func updateSavedSettings() {
        mainPageVC?.reloadAllVC()
    }
    
    func reload() {
        viewModel.updateHorizontalData()
        collectionView.reloadData()
    }
}

final class RocketVC: UIViewController {
    
    private var collectionView: UICollectionView!
    public weak var mainPageVC: MainPageVCProtocol?
    private var viewModel: RocketViewModelProtocol!
    init(rocket: RocketModel) {
        super.init(nibName: nil, bundle: nil)
        setupScreen()
        viewModel = RocketViewModel(viewController: self, rocket: rocket)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupScreen() {
        createCollectionView()
        self.navigationController?.view.backgroundColor = .white
    }
    private func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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

    
    private func registerCells() {
        self.collectionView.register(RocketTopCell.self, forCellWithReuseIdentifier: "CellForTop")
        self.collectionView.register(RocketVerticalItemCell.self, forCellWithReuseIdentifier: "CellForVerticalItem")
        self.collectionView.register(RocketHorizontalItemCell.self, forCellWithReuseIdentifier: "CellForHorizontalItem")
        self.collectionView.register(RocketLaunchButtonCell.self, forCellWithReuseIdentifier: "CellForButton")
    }


}


extension RocketVC: UICollectionViewDataSource {
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
    private func createCellForTop(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForTop",
                                                      for: indexPath) as? RocketTopCell
        guard let cell = cell else { return UICollectionViewCell() }
        cell.titleLabel.text = viewModel.titleRocket
        cell.navVC = self.navigationController // ретейн или нет?
        cell.delegate = self// cell -> SettingsVC -> cell- так ок?
        return cell
    }
    
    private func createCellForHorizontalItems(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForHorizontalItem",
                                                      for: indexPath) as? RocketHorizontalItemCell
        
        guard let cell = cell else { return UICollectionViewCell() }
        let model = viewModel.horizontalValues
        if model.count > 0 {
            cell.updateLabelsText(model: model[indexPath.row])
        }
        return cell
    }
    
    private func createCellForVerticalItems(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForVerticalItem",
                                                      for: indexPath) as? RocketVerticalItemCell
        guard let cell = cell else { return UICollectionViewCell() }
        let model = viewModel.verticalValues
        if model.count > 0 {
            cell.setCell(model: model[indexPath.row])
        }
        return cell
    }
    private func createCellForButton(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellForButton",
                                                      for: indexPath) as? RocketLaunchButtonCell
        
        guard let cell = cell else { return UICollectionViewCell() }
        cell.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return cell
    }
    @objc private func buttonAction() {
        let viewModel = LaunchVCViewModel(rocketName: viewModel.rocketName())
        let launchesVC = LaunchVC(viewModel: viewModel)
        launchesVC.title = self.viewModel.titleRocket
        navigationController?.pushViewController(launchesVC, animated: true)
    }
    
    // MARK: - CollectionView Sections and CompositionalLayout
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
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
    
    private func createTopSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(340)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(340)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    private func createHorizontalScrollSection() -> NSCollectionLayoutSection {
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
    private func createVerticalTableSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let margins: CGFloat = 10
        let countOfCells: CGFloat = 9
        let allMargins = countOfCells * margins
        let heightForCell: CGFloat = 40 // нужно знать как делать динамическую высоту для разных ячеек
        let heightForSection = heightForCell * countOfCells + allMargins
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .estimated(30)))
        // использовал тут estimated. - уместно?
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .estimated(heightForSection)), subitems: [item])
        group.interItemSpacing = .fixed(margins)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        return section
    }
    private func createButtonSection() -> NSCollectionLayoutSection {
        let height: CGFloat = 50
        let width: CGFloat = UIScreen.main.bounds.width - globalMargins * 2
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(width), heightDimension: .absolute(height)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: globalMargins, bottom: 20, trailing: 0)
        return section
    }
    
    
}

