//
// TaskCompletedCell.swift
// Ribbit
//
// Created by Ahsan Ali on 24/03/2021.
//
import UIKit
class TaskCompletedCell: UITableViewCell {
    @IBOutlet var lblPoints: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPoints.strikeThrough(true)
        lblTitle.strikeThrough(true)
        lblSubTitle.strikeThrough(true)
    }
}
