//
//  ProductViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 14/12/2022.
//

import UIKit

class ProductViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var products: [ProductModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        title = "Vegetables"
        configureCollectionView()
        registerCell()
    }
    func getProductCat(catId: String) {
        let url = URL(string: "http://localhost:5000/api/products?category=\(catId)")!
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
extension ProductViewController {
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    func registerCell() {
        collectionView.register(ProductCell.nib(), forCellWithReuseIdentifier: ProductCell.identifier)
    }
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 181, height: 234)
    }
}

extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: products[indexPath.row])
        return cell
    }
}
