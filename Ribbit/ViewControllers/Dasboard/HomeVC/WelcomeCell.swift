//
// WelcomeCell.swift
// Ribbit
//
// Created by Adnan Asghar on 3/24/21.
//

import Charts
import InitialsImageView
import UIKit
class WelcomeCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var month: UIButton!
    @IBOutlet var week: UIButton!
    @IBOutlet var day: UIButton!
    @IBOutlet var graph: LineChartView!
    var IDayBlock: (() -> Void)?
    var IWeekBlock: (() -> Void)?
    var IMonthBlock: (() -> Void)?

    @IBOutlet var userImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
        self.userImage.layer.masksToBounds = false
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        self.userImage.clipsToBounds = true
        lblName.text = "Hello " + (USER.shared.details?.user!.firstName?.capitalized)!
        let avatar = USER.shared.details?.user?.avatar ?? ""

        self.userImage.getImage(url: EndPoint.kServerBase + "file/users/"+avatar, placeholderImage: nil) { _ in
            self.userImage.contentMode = .scaleAspectFill
        } failer: { _ in
            self.userImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
        }
    }

    @IBAction func dayPressed(_ sender: Any) {
        self.day.setTitleColor(._715AFF, for: .normal)
        self.week.setTitleColor(._92ACB5, for: .normal)
        self.month.setTitleColor(._92ACB5, for: .normal)
        IDayBlock?()
    }

    @IBAction func weekPressed(_ sender: Any) {
        self.day.setTitleColor(._92ACB5, for: .normal)
        self.week.setTitleColor(._715AFF, for: .normal)
        self.month.setTitleColor(._92ACB5, for: .normal)
        IWeekBlock?()
    }

    @IBAction func monthPressed(_ sender: Any) {
        self.day.setTitleColor(._92ACB5, for: .normal)
        self.week.setTitleColor(._92ACB5, for: .normal)
        self.month.setTitleColor(._715AFF, for: .normal)
        IMonthBlock?()
    }
}
