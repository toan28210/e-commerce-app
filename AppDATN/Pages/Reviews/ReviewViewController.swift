//
//  ReviewViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    var productId = ""
    var reviews: [RatingModel] = []
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        title = "Reviews"
        tabBarController?.tabBar.isHidden = true
        configureColelctionView()
        registerCell()
        fetchRating()
    }
    func fetchRating() {
        let url = URL(string: "http://localhost:5000/api/rating/find/\(productId)")!
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
                    let jsonDecoder = JSONDecoder()
                    let json = try jsonDecoder.decode([RatingModel].self, from: data)
                    self.reviews = json
                    DispatchQueue.main.async {
                        self.reviewCollectionView.reloadData()
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }
    func configureColelctionView() {
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.collectionViewLayout = flowLayout
    }
    func registerCell() {
        reviewCollectionView.register(ReviewCell.nib(), forCellWithReuseIdentifier: ReviewCell.identifier)
    }
    @objc func addTapped() {
        let addReview = AddReviewViewController()
        addReview.productId = productId
        addReview.rating = reviews.count
        var reviewScore = 0.0
        for review in reviews {
            reviewScore += review.rating ?? 0.0
        }
        addReview.reviewScore = reviewScore
        navigationController?.pushViewController(addReview, animated: true)
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 169)
    }
}
extension ReviewViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: reviews[indexPath.row])
        return cell
    }
}
