//
//  FundsAddedVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/05/2021.
//

import UIKit

class FundsAddedVC: BaseVC {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblDepositCom: UILabel!
    @IBOutlet var lblavailtoTrade: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgRound: UIImageView!
    @IBOutlet var imgBar: UIImageView!
    @IBOutlet var lblCancel: UILabel!
    @IBOutlet var lblIntiate: UILabel!
    @IBOutlet var middleBar: UIImageView!
    @IBOutlet var startBar: UIImageView!
    @IBOutlet var startRound: UIImageView!
    var amount  = ""
    var time = ""
    var status  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAmount.text = "$\(amount) Added"
        lblTime.text = time
        let upperStatus = status.uppercased()

        if upperStatus == "COMPLETE" {
            startBar.tintColor = ._715AFF
            startRound.tintColor = ._715AFF
            middleBar.tintColor = ._715AFF
            imgBar.tintColor = ._715AFF
            imgRound.tintColor = ._715AFF
            lblIntiate.textColor = .lightGray
            lblCancel.textColor = .lightGray
            lblDepositCom.textColor = .black
        } else if upperStatus == "CANCELED" {
            startBar.tintColor = ._715AFF
            startRound.tintColor = ._715AFF
            middleBar.tintColor = .red
            imgBar.tintColor = .red
            imgRound.tintColor = .red
            lblIntiate.textColor = .lightGray
            lblCancel.textColor = .black
            lblDepositCom.textColor = .lightGray
        }
    }

    @IBAction func addFundsPressed(_ sender: UIButton) {
        let upperStatus = status.uppercased()
        if upperStatus == "COMPLETE" {
            FundsAddedRouter().route(to: "back", from: self, parameters: nil, animated: true)
        } else if upperStatus == "CANCELED" {
            self.lblAmount.text = "$\(amount) Canceled"
            self.lblTitle.text = "Funds Canceled"
            self.lblDepositCom.text = "Deposit Canceled"
            self.lblavailtoTrade.text = ""
            self.imgRound.image = #imageLiteral(resourceName: "circleBlue")
            self.imgBar.image = #imageLiteral(resourceName: "BarBlue")
        } else {
            FundsAddedRouter().routeToParent(to: "back", from: self, parameters: nil, animated: true)
        }
    }
}
