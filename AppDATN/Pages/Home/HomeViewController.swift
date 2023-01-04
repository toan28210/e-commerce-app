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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
        configureCollectonView()
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
        collectionView.register(ProductViewCell.nib(), forCellWithReuseIdentifier: ProductViewCell.identifier)
    }
}

// MARK: - CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            guard let homeCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductViewCell.identifier, for: indexPath) as? ProductViewCell else {
                return UICollectionViewCell()
            }
            return homeCategoryCell
        }
        return UICollectionViewCell()
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
        }
        return CGSize(width: 0, height: 0)
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
