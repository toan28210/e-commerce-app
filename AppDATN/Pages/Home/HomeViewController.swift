//
//  HomeViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var products: [ProductModel] = []
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
        configureCollectonView()
        getDataProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    @IBAction func hanleSearch(_ sender: UIButton) {
        let search = SearchViewController()
        navigationController?.pushViewController(search, animated: true)
    }
    
    private func configureCollectonView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SlideCell.nib(), forCellWithReuseIdentifier: SlideCell.identifier)
        collectionView.register(CategoryCell.nib(), forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.register(TopProductCell.nib(), forCellWithReuseIdentifier: TopProductCell.identifier)
        collectionView.register(ProductCell.nib(), forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(CategoryHeaderView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: CategoryHeaderView.identifier)
    }
    
    private func getDataProducts() {
        let url = URL(string: "http://localhost:5000/api/products")!
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
                    let json = try jsonDecoder.decode([ProductModel].self, from: data)
                    self.products = json
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
}

// MARK: - CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            return products.count
        }
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let homeSlideCell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideCell.identifier, for: indexPath) as? SlideCell else {
                return UICollectionViewCell()
            }
            return homeSlideCell
        } else if indexPath.section == 1 {
            guard let homeCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            homeCategoryCell.cateDelegate = self
            return homeCategoryCell
        } else if indexPath.section == 2 {
            guard let homeTopCell = collectionView.dequeueReusableCell(withReuseIdentifier: TopProductCell.identifier, for: indexPath) as? TopProductCell else {
                return UICollectionViewCell()
            }
            homeTopCell.delegate = self
            return homeTopCell
        } else if indexPath.section == 3 {
            guard let productsCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
                return UICollectionViewCell()
            }
            productsCell.configure(with: products[indexPath.row])
            return productsCell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryHeaderView.identifier,
            for: indexPath) as? CategoryHeaderView else {
            return CategoryHeaderView()
        }
        header.superView.namHeaedr.text = "Products"
        return header
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 3 {
            return CGSize(width: collectionView.frame.width, height: 50)
        } else {return CGSize(width: 0, height: 0)}
    }
    
}

// MARK: - Collection View Delegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.frame.width, height: 170)
        } else if indexPath.section == 2 {
            return CGSize(width: collectionView.frame.width, height: 300)
        } else if indexPath.section == 3 {
            let numberOfItemsPerRow: CGFloat = 2
            let padding: CGFloat = 24
            let width = collectionView.bounds.width
            let spacing: CGFloat = flowLayout.minimumInteritemSpacing
            let availableWidth = width - spacing * (numberOfItemsPerRow + 1) - padding * 2
            let itemDimension = floor(availableWidth / numberOfItemsPerRow)
            let height: CGFloat = 300
            return CGSize(width: itemDimension, height: height)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 3 {
            return flowLayout.sectionInset
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension HomeViewController: CategoryCellDelegate {
    func getProductFollowCat(catId: String, title: String) {
        let productVC = ProductViewController()
        productVC.getProductCat(catId: catId)
        productVC.title = title
        navigationController?.pushViewController(productVC, animated: true)
    }
    func see(categories: [CategoryModel]) {
        let catVC = CategoryViewController()
        catVC.categories = categories
        navigationController?.pushViewController(catVC, animated: true)
    }
}

extension HomeViewController: TopProductCellDelegate {
    func fetchProduct(product: ProductModel) {
        let detail = ProductDetailViewController()
        detail.product = product
        navigationController?.pushViewController(detail, animated: true)
    }
}
