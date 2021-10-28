//
// RewardHeaderView.swift
// Ribbit
//
// Created by Ahsan Ali on 29/03/2021.
//
import UIKit
class RewardHeaderView: UICollectionReusableView {
    // MARK: - Outlets
    @IBOutlet var backview: UIView!
    // MARK: - Cycles
    override func draw(_ rect: CGRect) {
        backview.layer.cornerRadius = 15
        backview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
