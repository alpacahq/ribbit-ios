//
//  WorkInfoVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//

import SSSpinnerButton
import TweeTextField
import UIKit

class WorkInfoVC: BaseVC {
    @IBOutlet var txtEmployer: TweeAttributedTextField! {
        didSet {
            txtEmployer.delegate = self
        }
    }
    @IBOutlet var txtStock: TweeAttributedTextField! {
        didSet {
            txtStock.delegate = self
        }
    }
    private var workViewModel: WorkModel!
    @IBOutlet var btnContinue: SSSpinnerButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }
    @IBAction func continuePressed(_ sender: Any) {
        self.callToViewModelForUIUpdate(employerName: txtEmployer.text!, occupation: txtStock.text!)
    }
    private func callToViewModelForUIUpdate(employerName: String, occupation: String) {
        btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        self.workViewModel = WorkModel(employerName: txtEmployer.text!, oocupation: txtStock.text!)
        self.workViewModel.bindViewModelToController = {
            self.btnContinue.stopAnimate(complete: nil)
            WorkRoute().route(to: ShareholderQuestionVC.identifier, from: self, parameters: nil, animated: true)
        }
        self.workViewModel.bindErrorViewModelToController = { _ in
            self.btnContinue.stopAnimate(complete: nil)
        }
    }
    private func setDataOnView() {
        self.txtEmployer.text = USER.shared.details?.user?.employerName
        self.txtStock.text = USER.shared.details?.user?.occupation
        if !self.txtEmployer.text!.isEmpty && !self.txtStock.text!.isEmpty {
            btnContinue.setBackground(enable: true)
        }
    }
}
extension WorkInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmployer {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtEmployer.showInfo(errorMsg)
                btnContinue.setBackground(enable: false)
            } else {
                txtEmployer.showInfo("")
            }
            return true
        } else {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtStock.showInfo(errorMsg)
                btnContinue.setBackground(enable: false)
            } else {
                btnContinue.setBackground(enable: true)
                txtStock.showInfo("")
            }
            return true
        }
    }
}
