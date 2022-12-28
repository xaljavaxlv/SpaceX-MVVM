//
//  ViewController.swift
//  SpaceX MVVM
//
//  Created by Vlad Zavada on 12/23/22.
//

import UIKit

protocol RocketVCProtocol: AnyObject {
    var mainPageVC: MainPageVCProtocol? { get set }
    var navigationController: UINavigationController? { get }
    func reload()
    func updateSavedSettings()
}

final class RocketVC: UIViewController {

    private var collectionView: UICollectionView!
    public weak var mainPageVC: MainPageVCProtocol?
    private var viewModel: RocketViewModelProtocol!
    typealias DataSource = UICollectionViewDiffableDataSource<RocketSectionModel, RocketItemType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<RocketSectionModel, RocketItemType>
    private lazy var dataSource = createDataSource()

    init(viewModel: RocketViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        setupScreen()
        self.viewModel = viewModel
        viewModel.viewController = self
        applySnapshot(animatingDifferences: false)
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
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                              constant: 0).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -70).isActive = true //
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: 0).isActive = true
//        collectionView.bounces = false // не уверен - проверить что это вообще такое
        //collectionView.dataSource = self
        collectionView.backgroundColor = .black
        registerCells()
    }

    private func registerCells() {
        collectionView.register(RocketTopCell.self, forCellWithReuseIdentifier: "CellForTop")
        collectionView.register(RocketHorizontalItemCell.self, forCellWithReuseIdentifier: "CellForHorizontalItem")
        collectionView.register(RocketVerticalGeneralCell.self, forCellWithReuseIdentifier: "CellForVerticalItem")
        collectionView.register(RocketVerticalStagesCell.self,
                                     forCellWithReuseIdentifier: "RocketVerticalFirstStageCell")
        collectionView.register(RocketLaunchButtonCell.self, forCellWithReuseIdentifier: "CellForButton")
//        collectionView.register(RocketVerticalStageHeader.self, forSupplementaryViewOfKind: "RocketVerticalStageHeader", withReuseIdentifier: "RocketVerticalStageHeader")
        collectionView.register(RocketVerticalStageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RocketVerticalStageHeader")

    }
}

// MARK: - UICollectionView Diffable DataSource
extension RocketVC {
    func createDataSource() -> DataSource {
        let dataSource = DataSource( collectionView: collectionView,
                                     cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            //          let cell = collectionView.dequeueReusableCell( // эту херь перебираем в свитч кейсах по item/ aka video 6.49
            //            withReuseIdentifier: "VideoCollectionViewCell",
            //            for: indexPath) as? VideoCollectionViewCell
            //          cell?.video = video
            //          return cell
            guard let self = self else { return nil }
            switch item {
            case .header(title: let title, image: let image):
                return self.createCellForHeader(indexPath: indexPath, title: title, imageUrl: image)
            case .info(cellItem: let cellItem):
                return self.createCellForHorizontalItems(indexPath: indexPath, cellItem: cellItem)
            case .button:
                return self.createCellForButton(indexPath: indexPath)
            }
        })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.sections)
        viewModel.sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}


// MARK: - UICollectionViewDataSource
extension RocketVC { // : UICollectionViewDataSource

//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        6
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 1
//        case 1: return viewModel.horizontalValues.count
//        case 2: return viewModel.verticalGeneralValues.count
//        case 3: return viewModel.verticalFirstStageValues.count
//        case 4: return viewModel.verticalSecondStageValues.count
//        case 5: return 1
//        default: return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0: return createCellForHeader(indexPath: indexPath)
//        case 1: return createCellForHorizontalItems(indexPath: indexPath)
//        case 2: return createCellForVerticalGeneralItems(indexPath: indexPath)
//        case 3: return createCellForVerticalFirstSectionItems(indexPath: indexPath)
//        case 4: return createCellForVerticalSecondSectionItems(indexPath: indexPath)
//        case 5: return createCellForButton(indexPath: indexPath)
//        default: return createCellForHeader(indexPath: indexPath)
//        }
//    }

    private func createCellForHeader(indexPath: IndexPath, title: String, imageUrl: URL) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CellForTop", for: indexPath) as? RocketTopCell else { return UICollectionViewCell() }
    cell.setCell(title: title, delegate: self)
        return cell
    }

    private func createCellForHorizontalItems(indexPath: IndexPath, cellItem: RocketCellItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CellForHorizontalItem",
            for: indexPath) as? RocketHorizontalItemCell else { return UICollectionViewCell() }

//        let model = viewModel.horizontalValues
//        if model.count > 0 {
//            cell.updateLabelsText(model: model[indexPath.row])
//        }
        cell.updateLabelsText(model: cellItem)
        return cell
    }

    private func createCellForVerticalGeneralItems(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CellForVerticalItem", // CellForVerticalItem
            for: indexPath) as? RocketVerticalGeneralCell else { return UICollectionViewCell() } // RocketVerticalGeneralCell

//        let model = viewModel.verticalGeneralValues
//        if model.count > 0 {
//            cell.setCell(model: model[indexPath.row])
//        }
        return cell
    }

    private func createCellForVerticalFirstSectionItems(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RocketVerticalFirstStageCell",
            for: indexPath) as? RocketVerticalStagesCell else { return UICollectionViewCell() }

//        let model = viewModel.verticalFirstStageValues
//        if model.count > 0 {
//            cell.setCell(model: model[indexPath.row])
//        }
        return cell
    }

    private func createCellForVerticalSecondSectionItems(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RocketVerticalFirstStageCell",
            for: indexPath) as? RocketVerticalStagesCell else { return UICollectionViewCell() }

//        let model = viewModel.verticalSecondStageValues
//        if model.count > 0 {
//            cell.setCell(model: model[indexPath.row])
//        }
        return cell
    }

    private func createCellForButton(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CellForButton",
            for: indexPath) as? RocketLaunchButtonCell else { return UICollectionViewCell() }
        cell.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return cell
    }

    @objc private func buttonAction() {
        guard let buttonIndex = viewModel.sections.firstIndex(where: ({ $0.type == .button })) else { return }
        let buttonSection = viewModel.sections[buttonIndex]
        guard let buttonItem = buttonSection.items.first else { return }
        // TODO: rename rocketName to rocketId  если все работает ок
        let launchViewModel = LaunchVCViewModel(rocketName: buttonItem.rocketId)
        let launchesVC = LaunchVC(viewModel: launchViewModel)
        guard let title = buttonSection.title else { return }
        launchesVC.title = title
        navigationController?.pushViewController(launchesVC, animated: true)
    }

    // MARK: - CollectionView Sections and CompositionalLayout

    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _  in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0: return self.createTopSection()
            case 1: return self.createHorizontalScrollSection()
            case 2: return self.createVerticalGeneralSection()
            case 3: return self.createVerticalStageSection()
            case 4: return self.createVerticalStageSection()
            case 5: return self.createButtonSection()
            default: return self.createHorizontalScrollSection()
            }
        }
    }

    private func createTopSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .absolute(340)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                .init(widthDimension: .absolute(width), heightDimension: .absolute(340)), subitems: [item])
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
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(withForCell),
                                                            heightDimension: .absolute(withForCell)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                .init(widthDimension: .absolute(widthForSection),
                      heightDimension: .absolute(withForCell)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(margins)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 20, leading: margins, bottom: 0, trailing: 0)
        return section
    }

    private func createVerticalGeneralSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let margins: CGFloat = 10
        let countOfCells: CGFloat = 9
        let allMargins = countOfCells * margins
        let heightForCell: CGFloat = 40
        let heightForSection = heightForCell * countOfCells + allMargins
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .absolute(width), heightDimension: .estimated(30)))
        // использовал тут estimated. - уместно?
        let group = NSCollectionLayoutGroup.vertical(layoutSize:
                .init(widthDimension: .absolute(width),
                      heightDimension: .estimated(heightForSection)),
                                                     subitems: [item])
        group.interItemSpacing = .fixed(margins)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    private func createVerticalStageSection() -> NSCollectionLayoutSection {
        let width = UIScreen.main.bounds.width
        let margins: CGFloat = 10
        let countOfCells: CGFloat = 9
        let allMargins = countOfCells * margins
        let heightForCell: CGFloat = 40
        let heightForSection = heightForCell * countOfCells + allMargins
        let item = NSCollectionLayoutItem(layoutSize:
                .init(widthDimension: .absolute(width), heightDimension: .estimated(30)))
        // использовал тут estimated. - уместно?
        let group = NSCollectionLayoutGroup.vertical(layoutSize:
                .init(widthDimension: .absolute(width),
                      heightDimension: .estimated(heightForSection)),
                                                     subitems: [item])
        group.interItemSpacing = .fixed(margins)
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "RocketVerticalStageHeader", alignment: .top) // хуйня блять не работает

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerItem]
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        return section
    }

    private func createButtonSection() -> NSCollectionLayoutSection {
        let height: CGFloat = 50
        let width: CGFloat = UIScreen.main.bounds.width - globalMargins * 2
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .absolute(50)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize:
                .init(widthDimension: .absolute(width),
                      heightDimension: .absolute(height)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: globalMargins, bottom: 20, trailing: 0)
        return section
    }
}


// MARK: - Conforming RocketVCProtocol

extension RocketVC: RocketVCProtocol {

    func updateSavedSettings() {
        mainPageVC?.reloadAllVC()
    }

    func reload() {
//        viewModel.updateHorizontalData()
        collectionView.reloadData()
    }
}

