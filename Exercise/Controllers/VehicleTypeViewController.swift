//
//  VehicleTypeViewController.swift
//  Exercise
//

import UIKit

class VehicleTypeViewController: UIViewController {
    enum Section: CaseIterable {
        case main
    }
    var dataSource: UICollectionViewDiffableDataSource<Section, VehicleType>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Vehicle Type"
        collectionView.register(UINib(nibName: "VehicleTypeCell", bundle: .main), forCellWithReuseIdentifier: "VehicleTypeCell")
        createLayout()
        configureDataSource()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension VehicleTypeViewController {
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, VehicleType>(collectionView: collectionView) {
            (collectionView, indexPath, type) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleTypeCell", for: indexPath) as? VehicleTypeCell
            cell?.configCell(type: type)
            return cell
            
        }
        generateDataSource()
    }
    
    private func createLayout() {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let spacing = CGFloat(2)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(90))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 4, trailing: 16)
            
            return section
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func generateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, VehicleType>()
        snapshot.appendSections([.main])
        snapshot.appendItems(VehicleType.allTypes())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

