//
//  FundingSourceVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 03/05/2021.

// MARK: - Choose multiple options of funding source.

import SSSpinnerButton
import UIKit
class FundingSourceVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var  btnEmploymentInc: UIButton!
    @IBOutlet var  btnInvestment: UIButton!
    @IBOutlet var  btnInheritance: UIButton!
    @IBOutlet var  btnBusiness: UIButton!
    @IBOutlet var  btnSaving: UIButton!
    @IBOutlet var  btnFamily: UIButton!
    @IBOutlet var btnCont: SSSpinnerButton!

    var tagsArray = [String]()

    // MARK: - variables
    private var lastSelectedbtn: UIButton?
    private var fundViewModel: FundingSourceViewModel!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataOnView()
    }

    // MARK: - Actions

    @IBAction func optionPressed(_ sender: UIButton) {
        selectButton(sender)
    }

    @IBAction func continuePressed(_ sender: SSSpinnerButton) {
        if self.tagsArray.count > 0 {
            sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
                self.updateProfile(sender: sender)
            })
        }
    }

    fileprivate func selectButton(_ sender: UIButton) {
        var matchStr: String! = ""

        if sender.titleLabel?.text == "Employment Income" {
            matchStr = "employment_income"
        } else if sender.titleLabel?.text == "Investment" {
            matchStr = "investments"
        } else if sender.titleLabel?.text == "Inheritance" {
            matchStr = "inheritance"
        } else if sender.titleLabel?.text == "Business Income" {
            matchStr = "business_income"
        } else if sender.titleLabel?.text == "Family" {
            matchStr = "family"
        } else {
            matchStr = "savings"
        }

        if !self.tagsArray.contains(matchStr ?? "") {
            sender.borderColorV = ._715AFF
            print(sender.titleLabel?.text ?? "")

            if sender.titleLabel?.text == "Employment Income" {
                self.tagsArray.append(matchStr)
            } else if sender.titleLabel?.text == "Investment" {
                self.tagsArray.append(matchStr)
            } else if sender.titleLabel?.text == "Inheritance" {
                self.tagsArray.append(matchStr)
            } else if sender.titleLabel?.text == "Business Income" {
                self.tagsArray.append(matchStr)
            } else if sender.titleLabel?.text == "Family" {
                self.tagsArray.append(matchStr)
            } else {
                self.tagsArray.append(matchStr)
            }
        } else {
            if sender.titleLabel?.text == "Employment Income" {
                self.tagsArray.remove(object: matchStr)
            } else if sender.titleLabel?.text == "Investment" {
                self.tagsArray.remove(object: matchStr)
            } else if sender.titleLabel?.text == "Inheritance" {
                self.tagsArray.remove(object: matchStr)
            } else if sender.titleLabel?.text == "Business Income" {
                self.tagsArray.remove(object: matchStr)
            } else if sender.titleLabel?.text == "Family" {
                self.tagsArray.remove(object: matchStr)
            } else {
                self.tagsArray.remove(object: matchStr)
            }

            sender.borderColorV = UIColor(named: "lightgray 50%")
        }

        btnCont.setBackground(enable: true)
    }

    private func updateProfile(sender: SSSpinnerButton) {
        let formattedArray = (self.tagsArray.map { String($0) }).joined(separator: ",")
        fundViewModel = FundingSourceViewModel(fundingSource: formattedArray)
        fundViewModel.sender = sender
        fundViewModel.bindViewModelToController = {
            sender.stopAnimate {
                let router = FundingSourceRouter()
                router.route(to: EmployedVC.identifier, from: self, parameters: nil, animated: true)
            }
        }
    }

    private func setDataOnView() {
        self.tagsArray.removeAll()

        if  let fundingSource = USER.shared.details?.user?.fundingSource, fundingSource != "" {
            self.tagsArray = fundingSource.components(separatedBy: ",")
            print(self.tagsArray.count)

            for index in 0..<tagsArray.count {
                let item = self.tagsArray[index]

                switch item {
                case "employment_income":
                    btnEmploymentInc.borderColorV = ._715AFF
                case "investments":
                    btnInvestment.borderColorV = ._715AFF
                case "inheritance":
                    btnInheritance.borderColorV = ._715AFF
                case "business_income":
                    btnBusiness.borderColorV = ._715AFF
                case "Family":
                    btnFamily.borderColorV = ._715AFF
                default:
                    btnSaving.borderColorV = ._715AFF
                }
            }

            btnCont.setBackground(enable: true)
        } else {
            btnCont.setBackground(enable: false)
        }
    }
}
// MARK: - array comparing extention

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else { return }
        remove(at: index)
    }
}
