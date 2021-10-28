//
//  LandingPageView.swift
//  Ribbit
//
//  Created by Rao Mudassar on 20/07/2021.
//

import UIKit
struct LandingPageView {
    var description: String
    static var count: Int {
        return onboardingItems.count
    }
    static var onboardingItems: [LandingPageView] {
        let itemFirst: LandingPageView!
        let itemSecond: LandingPageView!
        itemFirst = LandingPageView(description: "Invest commission free in U.S. stocks")
        itemSecond = LandingPageView(description: "This app is operated by Alpaca Securities, LLC, an SEC registered broker-dealer & member FINRA/SIPC")

        return [itemFirst, itemSecond]
    }
}
