//
//  PreviewCellTableViewCell.swift
//  Ribbit
//
//  Created by Rao Mudassar on 18/07/2021.
//

import UIKit

class PreviewCellTableViewCell: UITableViewCell {
    @IBOutlet var status: UILabel!
    @IBOutlet var value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
