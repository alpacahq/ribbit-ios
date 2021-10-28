//
// TicketView.swift
// Ribbit
//
// Created by Adnan Asghar on 3/23/21.

import UIKit

class TicketView: UIView {
    // MARK: - IBOutlets

    @IBOutlet private var backgroundImage: UIImageView!

    @IBOutlet private var starImage: UIImageView!

    @IBOutlet private var lblTitle: UILabel!

    // MARK: - Variables

    var backgroundTint: UIColor = ._FFE68B {
        didSet {
            backgroundImage.tintColor = backgroundTint
        }
    }

    var starTint: UIColor? = ._7A5F4B {
        didSet {
            starImage.tintColor = starTint
        }
    }

    var titleText: String? = "" {
        didSet {
            lblTitle.text = titleText
        }
    }

    var titleTint: UIColor? = ._7A5F4B {
        didSet {
            lblTitle.textColor = titleTint
        }
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
