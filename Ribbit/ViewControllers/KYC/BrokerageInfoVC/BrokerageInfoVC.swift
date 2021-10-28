//
//  BrokerageInfoVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 30/06/2021.
//
import SSSpinnerButton
import TweeTextField
import UIKit

class BrokerageInfoVC: BaseVC {
    @IBOutlet var txtCompany: TweeAttributedTextField! {
        didSet {
            txtCompany.delegate = self
        }
    }
    @IBOutlet var txtPerson: TweeAttributedTextField! {
        didSet {
            txtPerson.delegate = self
        }
    }
    @IBOutlet var txtRelation: TweeAttributedTextField! {
        didSet {
            txtRelation.delegate = self
        }
    }
    private var brokageViewModel: BrokageInfoModel!
    @IBOutlet var btnContinue: SSSpinnerButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }

    @IBAction func continuePressed(_ sender: Any) {
        self.callToViewModelForUIUpdate(companyName: txtCompany.text!, person: txtPerson.text!, relation: txtRelation.text!)
    }
    private func callToViewModelForUIUpdate(companyName: String, person: String, relation: String) {
        btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)
        self.brokageViewModel = BrokageInfoModel(companyName: companyName, person: person, relation: relation)
        self.brokageViewModel.bindViewModelToController = {
            self.btnContinue.stopAnimate(complete: nil)
            BrokerageInfoRoute().route(to: PreviewApplicationVC.identifier, from: self, parameters: nil, animated: true)
        }
        self.brokageViewModel.bindErrorViewModelToController = { _ in
            self.btnContinue.stopAnimate(complete: nil)
        }
    }
    private func setDataOnView() {
        self.txtCompany.text = USER.shared.details?.user?.brokerageFirmName
        self.txtPerson.text = USER.shared.details?.user?.brokerageFirmEmployeeName
        self.txtRelation.text = USER.shared.details?.user?.brokerageFirmEmployeeRelationship
        if !self.txtCompany.text!.isEmpty && !self.txtPerson.text!.isEmpty && !self.txtRelation.text!.isEmpty {
            btnContinue.setBackground(enable: true)
        }
    }
}
extension BrokerageInfoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCompany {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtCompany.showInfo(errorMsg)
                btnContinue.setBackground(enable: false)
            } else {
                txtCompany.showInfo("")
            }
            return true
        } else if textField == txtPerson {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtPerson.showInfo(errorMsg)
                btnContinue.setBackground(enable: false)
            } else {
                txtPerson.showInfo("")
            }
            return true
        } else {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            let validator = Validator()
            if let errorMsg = validator.validate(text: updatedText, with: [.notEmpty]) {
                txtRelation.showInfo(errorMsg)
                btnContinue.setBackground(enable: false)
            } else {
                txtRelation.showInfo("")
                btnContinue.setBackground(enable: true)
            }
            return true
        }
    }
}
