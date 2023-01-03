//
//  CategoryCell.swift
//  AppDATN
//
//  Created by Toan Tran on 20/12/2022.
//

import UIKit
protocol CategoryCellDelegate: AnyObject {
    func see(categories: [CategoryModel])
    func getProductFollowCat(catId: String)
}

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    static func nib() -> UINib {
        return UINib(nibName: CategoryCell.identifier, bundle: .main)
    }
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    weak var cateDelegate: CategoryCellDelegate?
    var categories: [CategoryModel] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCollectionView()
        getDataCategories()
    }
    func getDataCategories() {
        let url = URL(string: "http://localhost:5000/api/categories")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                guard let response = res as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                do {
                    guard let data = data else {
                        return
                    }
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonDecoder = JSONDecoder()
                    let json = try jsonDecoder.decode([CategoryModel].self, from: data)
                    self.categories = json
                    DispatchQueue.main.async {
                        self.categoryCollectionView.reloadData()
                    }
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    func configureCollectionView() {
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.collectionViewLayout = createLayout()
        categoryCollectionView.register(CategoryItemCell.nib(), forCellWithReuseIdentifier: CategoryItemCell.identifier)
        categoryCollectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.identifier)
    }
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(108),
                                              heightDimension: .absolute(119))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(108),
                                               heightDimension: .absolute(119))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension CategoryCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
}

extension CategoryCell: UICollectionViewDataSource {
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
    // Header Collection View
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeaderView.identifier,
            for: indexPath) as? CategoryHeaderView else {
            return UICollectionReusableView()
        }
        header.superView.delegate = self
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cateDelegate?.getProductFollowCat(catId: categories[indexPath.row].cat ?? "")
    }
}

extension CategoryCell: CategoryHeaerDelegate {
    func seeAll() {
        self.cateDelegate?.see(categories: categories)
    }
}
