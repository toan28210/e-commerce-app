//
//  CategoryViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 21/12/2022.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var catCollectionView: UICollectionView!
    var categories: [CategoryModel] = []
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        navigationController?.isNavigationBarHidden = false
        configureCollectionView()
    }
    func configureCollectionView() {
        catCollectionView.collectionViewLayout = flowLayout
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        catCollectionView.register(CategoryItemCell.nib(), forCellWithReuseIdentifier: CategoryItemCell.identifier)
    }
    
}
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
                let numberOfItemsPerRow: CGFloat = 3
                let spacing: CGFloat = flowLayout.minimumInteritemSpacing
                let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
                let itemDimension = floor(availableWidth / numberOfItemsPerRow)
                return CGSize(width: itemDimension, height: itemDimension)
    }
}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.identifier, for: indexPath) as? CategoryItemCell else {
            return UICollectionViewCell()
        }
        cell.configureCollectionView(with: categories[indexPath.row])
        return cell
    }
    
    
}
