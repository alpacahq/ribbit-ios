//
// FavStockCell.swift
// Ribbit
//
// Created by Rao Mudassar on 29/07/2021.
//
import UIKit
class FavStockCell: UITableViewCell {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnViewAll: UIButton!
    var actionBlock: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func buttonAllViewTap(sender: AnyObject) {
        actionBlock?()
    }
}
