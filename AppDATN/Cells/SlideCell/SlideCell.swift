//
//  SlideCell.swift
//  AppDATN
//
//  Created by Toan Tran on 20/12/2022.
//

import UIKit

class SlideCell: UICollectionViewCell {
    static let identifier = "SlideCell"
    static func nib() -> UINib {
        return UINib(nibName: SlideCell.identifier, bundle: .main)
    }
    
    @IBOutlet weak var collectiionView: UICollectionView!
    let slideDatas = SlideModels.shared.getDataSlide()
    var timer = Timer()
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    @objc func slideToNext() {
        if index < slideDatas.count - 1 {
            index += 1
        } else {
            index = 0
        }
        collectiionView.isPagingEnabled = false
        collectiionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true)
        collectiionView.isPagingEnabled = true
    }
    func configureCollectionView() {
        collectiionView.delegate = self
        collectiionView.dataSource = self
        collectiionView.collectionViewLayout = createLayout()
        collectiionView.register(HomeSlideCell.nib(), forCellWithReuseIdentifier: HomeSlideCell.identifier)
    }
}

extension SlideCell {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension SlideCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
}

extension SlideCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slideDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let homeSlideCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSlideCell.identifier, for: indexPath) as? HomeSlideCell else {
            return UICollectionViewCell()
        }
        homeSlideCell.configureView(with: slideDatas[indexPath.row])
        return homeSlideCell
    }
}
