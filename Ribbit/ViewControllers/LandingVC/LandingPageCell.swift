//
//  LandingPageCell.swift
//  Ribbit
//
//  Created by Rao Mudassar on 20/07/2021.
//

import UIKit

class LandingPageCell: UICollectionViewCell {
    @IBOutlet var landingFirst: UILabel!

    @IBOutlet var landingSecond: UILabel!

    @IBOutlet var landingThird: UILabel!

    func configure(with guideItems: LandingPageView) {
        if guideItems.description == "Invest commission free in U.S. stocks" {
            self.landingSecond.alpha = 0
            self.landingFirst.alpha = 1
            self.landingThird.alpha = 1
        } else {
            self.landingSecond.alpha = 1
            self.landingFirst.alpha = 0
            self.landingThird.alpha = 0
        }
    }
}
