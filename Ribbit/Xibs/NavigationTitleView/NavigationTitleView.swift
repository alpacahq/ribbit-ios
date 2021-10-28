//
// NavigationTitleView.swift
// Ribbit
//
// Created by Adnan Asghar on 3/23/21.

import UIKit

class NavigationTitleView: UIView {
    // MARK: - IBOutlets

    @IBOutlet private var imgIconBack: UIImageView!
    @IBOutlet private var lblTitle: UILabel!

    // MARK: - Variables

    var iconBackTint: UIColor = ._715AFF {
        didSet {
            imgIconBack.tintColor = iconBackTint
        }
    }

    var titleTint: UIColor? = ._242234 {
        didSet {
            lblTitle.textColor = titleTint
        }
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
}
