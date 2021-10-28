//
// ReferelCodeVC.swift
// Ribbit
//
// Created by Ahsan Ali on 03/06/2021.
//

import SSSpinnerButton
import TweeTextField
import UIKit
class ReferelCodeVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var txtCode: TextFieldWithPadding!
    @IBOutlet var btnCont: UIButton!
    @IBOutlet var refIMG: UIImageView!
    // MARK: - Vars
    private  var vModel: ReferelViewModel!
    weak var delegate: BackPressedDelegte?
    private var sender: SSSpinnerButton!

    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        vModel = ReferelViewModel()
        vModel.bindViewModelToController = {
            self.sender.stopAnimate(complete: nil)
            ReferelRouter().route(to: NameVC.identifier, from: self, parameters: nil, animated: true)
        }
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            delegate?.backPressed()
            consoleLog("back pressed")
        }
    }
    // MARK: - Actions
    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        txtCode.showInfo("")
        self.sender = sender
        let valid = Validator()

        if let errorMsg = valid.validate(text: txtCode.text!, with: [.notEmpty]) {
            txtCode.showInfo(errorMsg)
            return
        }

        vModel.sender = sender
        self.vModel.sendReferel(code: self.txtCode.text!)
        self.vModel.refrelBinded = { msg in
            if msg == "" {
                self.refIMG.isHidden = true
                self.sender.stopAnimate(complete: nil)
                self.view.makeToast("invalid referral Code")
                return
            } else {
                self.refIMG.isHidden = false
                self.view.makeToast("Successfully Verified")
                self.vModel.skipReffrel()
            }
        }

        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
        })
    }
    @IBAction func skipPressed(_ sender: SSSpinnerButton) {
        vModel.sender = sender
        self.sender = sender
        txtCode.showInfo("")
        self.vModel.skipReffrel()
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor._715AFF, spinnerSize: 20, complete: {
        })
    }
}
// MARK: - Textfield Delegate
extension ReferelCodeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let validator = Validator()
        if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
            txtCode.showInfo(errorMsg)
            btnCont.setBackground(enable: false)
        } else {
            btnCont.setBackground(enable: true)
            txtCode.showInfo("")
        }
        return true
    }
}
protocol BackPressedDelegte: AnyObject {
    func backPressed()
}
