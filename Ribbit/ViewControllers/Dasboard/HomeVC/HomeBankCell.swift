//
// HomeBankCell.swift
// Ribbit
//
// Created by Adnan Asghar on 3/24/21.
//
import UIKit
class HomeBankCell: UITableViewCell {
    @IBOutlet var ticketView: UIView!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
