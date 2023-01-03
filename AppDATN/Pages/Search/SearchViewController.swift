//
//  SearchViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 23/12/2022.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchCollectionView: UICollectionView!
    let searchHistory = ["ao", "quan", "Mu", "Balo", "Dien thoai","Laptop","Ao quan em be", "Scan"]
    let searchDis = ["ao", "quan", "Mu", "Balo", "Dien thoai","Laptop","Ao quan em be", "Scan", "BoDOI"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        configureCollectionView()
        setupCollectionView()
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        searchCollectionView.collectionViewLayout = layout
    }
    func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.register(SearchCell.nib(), forCellWithReuseIdentifier: SearchCell.identifier)
        searchCollectionView.register(SearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.identifier)
    }
    func setupCollectionView() {
        if let flowlayout = searchCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.minimumLineSpacing = 5
        }
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return searchHistory.count
        } else {
            return searchDis.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            cell.titleSearch.text = searchHistory[indexPath.row]
        } else if indexPath.section == 1 {
            cell.titleSearch.text = searchDis[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchHeaderView.identifier, for: indexPath) as? SearchHeaderView else {
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
            header.superView.titleLabel.text = "Search History"
        } else {
            header.superView.titleLabel.text = "Discover more"
        }
        return header
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}
