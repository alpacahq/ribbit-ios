//
//  StockCell.swift
//  Ribbit
//
//  Created by Ahsan Ali on 26/04/2021.
//

import UIKit

class StockCell: UITableViewCell {
    @IBOutlet var stockSymbol: UILabel!

    @IBOutlet var stockCompany: UILabel!

    @IBOutlet var stockGraph: UIImageView!

    @IBOutlet var stockImg: UIImageView!

    @IBOutlet var stockPer: UILabel!

    @IBOutlet var stockPrice: UILabel!

    @IBOutlet var arrowSign: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
