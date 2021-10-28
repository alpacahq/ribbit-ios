//
//  StockTickerCell.swift
//  Ribbit
//
//  Created by Rao Mudassar on 08/07/2021.
//

import UIKit

class StockTickerCell: UITableViewCell {
    @IBOutlet var stockSymbol: UILabel!

    @IBOutlet var stockOrg: UILabel!

    @IBOutlet var stockFav: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
