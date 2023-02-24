//
//  StartViewController.swift
//  AppDATN
//
//  Created by Toan Tran on 05/12/2022.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var startPageControl: UIPageControl!
    @IBOutlet private weak var startCollectionView: UICollectionView!
    @IBOutlet private weak var startButton: UIButton!
    let startDatas = StartSevice.shared.getStartDatas()
    var currentPage = 0 {
        didSet {
            startPageControl.currentPage = currentPage
            if currentPage == startDatas.count - 1 {
                startButton.setTitle("Bắt đầu", for: .normal)
            } else {
                startButton.setTitle("Tiếp", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        registerCollectionView()
        setupCollectionView()
        setupPageControl()
    }
    func scrollToSlideIndex(slideIndex: Int) {
        startCollectionView.isPagingEnabled = false
        startCollectionView.scrollToItem(at: IndexPath(item: slideIndex, section: 0), at: .centeredHorizontally, animated: true)
        startCollectionView.isPagingEnabled = true
    }
    @IBAction func handleClickGetStart(_ sender: UIButton) {
        if currentPage == startDatas.count - 1 {
            let welcome = WelcomeViewController()
            welcome.navigationController?.isNavigationBarHidden = true
            self.navigationController?.pushViewController(welcome, animated: true)
        } else {
            currentPage += 1
            scrollToSlideIndex(slideIndex: currentPage)
        }
    }
}
// MARK: - Configure Collection View
extension StartViewController {
    private func configureCollectionView() {
        startCollectionView.delegate = self
        startCollectionView.dataSource = self
    }
    private func registerCollectionView() {
        startCollectionView.register(StartCell.nib(), forCellWithReuseIdentifier: StartCell.identifier)
    }
}

// MARK: - Setup CollectionView Layout
extension StartViewController {
    func setupCollectionView() {
        if let flowlayout = startCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowlayout.minimumLineSpacing = 0
        }
    }
}
// MARK: - Setup Page Control
extension StartViewController {
    private func setupPageControl() {
        startPageControl.numberOfPages = startDatas.count
    }
}
// MARK: - Collection View DataSource
extension StartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return startDatas.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let startCell = collectionView.dequeueReusableCell(withReuseIdentifier: StartCell.identifier, for: indexPath) as? StartCell else {
            return StartCell()
        }
        
        startCell.configure(with: startDatas[indexPath.row])
        return startCell
    }
}
// MARK: - Collection View Delegate
extension StartViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = Int((startCollectionView.contentOffset.x / startCollectionView.frame.width).rounded(.toNearestOrAwayFromZero))
    }

}
