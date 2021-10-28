//
//  PreviewApplicationVC.swift
//  Ribbit
//
//  Created by Rao Mudassar on 01/07/2021.
//

import SSSpinnerButton
import UIKit

class PreviewApplicationVC: UIViewController {
    @IBOutlet var btnContinue: SSSpinnerButton!
    @IBOutlet var tableView: UITableView!
    var optionsArray = [String]()
    var valuesArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.optionsArray.removeAll()
        self.valuesArray.removeAll()
        let fname: String! = USER.shared.details?.user?.firstName ?? " "
        let lname: String! = USER.shared.details?.user?.lastName ?? " "
        let fullname = fname + " " + lname
        let email: String! = USER.shared.details?.user?.email ?? " "
        let city: String! = USER.shared.details?.user?.city ?? " "
        let state: String! = USER.shared.details?.user?.state ?? " "
        let address: String! = USER.shared.details?.user?.address ?? " "
        let apartment = USER.shared.details?.user?.apartment ?? " "
        let zip = USER.shared.details?.user?.zipCode ?? " "
        let country: String! = USER.shared.details?.user?.country ?? " "
        let str: String! = address + " " + apartment + " "
        let addess: String! = str + city + "," + state + " " + zip
        var phone: String! = self.format(with: "(XXX) XXX-XXXX", phone: USER.shared.details?.user?.mobile ?? "1234567890")
        if let phon = USER.shared.details?.user?.mobile, phon != "" {
            phone = phon.replacingOccurrences(of: "+1", with: "").applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")

            phone = "+1 " + phone
        }
        let dob: String! = self.convertDateFormater(USER.shared.details?.user?.dob ?? "1992-11-17")
        let SSN: String! = self.format(with: "XXX-XX-XXXX", phone: USER.shared.details?.user?.taxID ?? "123456789")
        let investingExperience: String! = USER.shared.details?.user?.investingExperience ?? " "
        let employmentStatus: String! = USER.shared.details?.user?.employmentStatus ?? " "
        let employerName: String! = USER.shared.details?.user?.employerName ?? " "
        let occupation: String! = USER.shared.details?.user?.occupation ?? " "
        let publicShareholder: String! = USER.shared.details?.user?.publicShareholder ?? " "
        let _: String! = USER.shared.details?.user?.shareholderCompanyName ?? "Apple Inc."
        let stockSymbol: String! = USER.shared.details?.user?.stockSymbol ?? " "
        let anotherBrokerage: String! = USER.shared.details?.user?.anotherBrokerage ?? " "
        let brokerageFirmName: String! = USER.shared.details?.user?.brokerageFirmName ?? " "
        let brokerageFirmEmployeeName: String! = USER.shared.details?.user?.brokerageFirmEmployeeName ?? " "
        let brokerageFirmEmployeeRelationship: String! = USER.shared.details?.user?.brokerageFirmEmployeeRelationship ?? "friend"
        self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "Employer Name", "Occupation", "10% Public Shareholder", "Stock Ticker", "Broker Affiliation", "Brokerage Company", "Broker Name", "Relation"]

        self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, employerName, occupation, publicShareholder, stockSymbol, anotherBrokerage, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship]

        if  USER.shared.details?.user?.employmentStatus != "employed" && USER.shared.details?.user?.publicShareholder == "no" && USER.shared.details?.user?.anotherBrokerage == "no" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "10% Public Shareholder", "Broker Affiliation"]

            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, publicShareholder, anotherBrokerage]
        } else if  USER.shared.details?.user?.employmentStatus != "employed" && USER.shared.details?.user?.publicShareholder == "no" && USER.shared.details?.user?.anotherBrokerage == "yes" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "10% Public Shareholder", "Broker Affiliation", "Brokerage Company", "Broker Name", "Relation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, publicShareholder, anotherBrokerage, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship]
        } else if  USER.shared.details?.user?.employmentStatus != "employed" && USER.shared.details?.user?.publicShareholder == "yes" && USER.shared.details?.user?.anotherBrokerage == "no" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "10% Public Shareholder", "Stock Ticker", "Broker Affiliation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, publicShareholder, stockSymbol, anotherBrokerage]
        } else if  USER.shared.details?.user?.employmentStatus != "employed" && USER.shared.details?.user?.publicShareholder == "yes" && USER.shared.details?.user?.anotherBrokerage == "yes" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "10% Public Shareholder", "Stock Ticker", "Broker Affiliation", "Brokerage Company", "Broker Name", "Relation"]

            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, publicShareholder, stockSymbol, anotherBrokerage, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship]
        } else if  USER.shared.details?.user?.employmentStatus == "employed" && USER.shared.details?.user?.publicShareholder == "no" && USER.shared.details?.user?.anotherBrokerage == "no" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "Employer Name", "Occupation", "10% Public Shareholder", "Broker Affiliation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, employerName, occupation, publicShareholder, anotherBrokerage]
        } else if  USER.shared.details?.user?.employmentStatus == "employed" && USER.shared.details?.user?.publicShareholder == "yes" && USER.shared.details?.user?.anotherBrokerage == "no" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "Employer Name", "Occupation", "10% Public Shareholder", "Stock Ticker", "Broker Affiliation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, employerName, occupation, publicShareholder, stockSymbol, anotherBrokerage]
        } else if USER.shared.details?.user?.employmentStatus == "employed" && USER.shared.details?.user?.publicShareholder == "no" && USER.shared.details?.user?.anotherBrokerage == "yes" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "Employer Name", "Occupation", "10% Public Shareholder", "Broker Affiliation", "Brokerage Company", "Broker Name", "Relation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, employerName, occupation, publicShareholder, anotherBrokerage, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship]
        } else if USER.shared.details?.user?.employmentStatus == "employed" && USER.shared.details?.user?.publicShareholder == "yes" && USER.shared.details?.user?.anotherBrokerage == "yes" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "Employer Name", "Occupation", "10% Public Shareholder", "Stock Ticker", "Broker Affiliation", "Brokerage Company", "Broker Name", "Relation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, employerName, occupation, publicShareholder, stockSymbol, anotherBrokerage, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship]
        } else if USER.shared.details?.user?.employmentStatus != "employed" && USER.shared.details?.user?.publicShareholder == "yes" && USER.shared.details?.user?.anotherBrokerage == "yes" {
            self.optionsArray = ["Name", "Email", "Phone", "DOB", "Address", "Citizenship", "SSN", "Trading Experience", "Employment Status", "10% Public Shareholder", "Broker Affiliation", "Brokerage Company", "Broker Name", "Relation"]
            self.valuesArray = [fullname, email, phone, dob, addess, country, SSN, investingExperience, employmentStatus, publicShareholder, anotherBrokerage, brokerageFirmName, brokerageFirmEmployeeName, brokerageFirmEmployeeRelationship]
        }

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }

    @IBAction func submit(_ sender: Any) {
        btnContinue.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: nil)

        PreviewApplicationRoute().route(to: PreviewApplicationVC.identifier, from: self, parameters: nil, animated: true)

        btnContinue.stopAnimate(complete: nil)
    }

    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers
        for chr in mask where index < numbers.endIndex {
            if chr == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(chr)
            }
        }
        return result
    }

    func convertDateFormater(_ date: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let parsed = inputFormatter.date(from: date) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy"
        return outputFormatter.string(from: parsed)
    }

    func format(_ unformatted: String) -> String {
        var formatted = ""
        let count = unformatted.count

        for (offset, char) in unformatted.enumerated() {
            if offset > 0 && offset % 3 == 0 && offset != count - 1 {
                formatted.append("-")
            } else if offset % 3 == 2 && offset == count - 2 {
                formatted.append("-")
            }
            formatted.append(char)
        }

        return formatted
    }
}

extension PreviewApplicationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.optionsArray[indexPath.row] != "Address" {
            let cell: PreviewCellTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell01") as? PreviewCellTableViewCell ?? PreviewCellTableViewCell()
            cell.status.text = self.optionsArray[indexPath.row]
            cell.value.text  = self.valuesArray[indexPath.row]

            return cell
        } else {
            let cell: AddressCell = self.tableView.dequeueReusableCell(withIdentifier: "cell02") as? AddressCell ?? AddressCell()

            cell.address.text = "Address"
            cell.street.text = USER.shared.details?.user?.address ?? " "
            cell.apartment.text = USER.shared.details?.user?.apartment ?? " "
            let city: String! = USER.shared.details?.user?.city ?? " "
            let state: String! = USER.shared.details?.user?.state ?? " "

            let zip = USER.shared.details?.user?.zipCode ?? " "
            let addess: String! = city + "," + state + " " + zip
            if USER.shared.details?.user?.apartment == " " || USER.shared.details?.user?.apartment == "" {
                cell.apartment.text = addess
            } else {
                cell.starte.text = addess
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.optionsArray[indexPath.row] != "Address" {
            return 50
        } else {
            return 80
        }
    }
}
