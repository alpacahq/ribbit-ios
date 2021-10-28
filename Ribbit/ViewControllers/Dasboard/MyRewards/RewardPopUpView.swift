//
// RewardPopUpVC.swift
// Ribbit
//
// Created by Ahsan Ali on 25/03/2021.
//
import UIKit

class RewardPopUpView: UIView {
    // MARK: - Outlets
    @IBOutlet var rewardCV: UICollectionView!
    // MARK: - LifeCycles
    @IBAction func addPressed(_ sender: UIButton) {
        removeFromSuperview()
    }
}
extension RewardPopUpView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.47
        return CGSize(width: width, height: width * 0.35)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardPopUpCell.identifier, for: indexPath) as? RewardPopUpCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
