//
// MagicLinkRouter.swift
// Ribbit
//
// Created by Ahsan Ali on 19/04/2021.
//

import UIKit

class MagicLinkRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if   routeID == "" {
            gotoReferel(from: context)
        } else {
            routeToExpected(too: routeID, from: context)
        }
    }

    func routeToOtp(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let OTPVC = UIStoryboard.main.instantiateViewController(withIdentifier: OTPVC.identifier) as? OTPVC {
            OTPVC.isSignUp = true
            context.navigationController?.pushViewController(OTPVC, animated: animated)
        }
    }
    private  func routeToExpected(too: String, from context: UIViewController) {
        if
            USER.shared.details?.user?.profileCompletion == "complete" &&
                USER.shared.details?.user?.accountStatus?.uppercased() == "APPROVED"
        {
            openDashboard(from: context)
        } else {
            let step = STEPS(rawValue: too)
            switch step {
            case .referral :
                gotoReferel(from: context, animated: true)
            case .name:
                gotoReferel(from: context)
                gotoName(from: context, animated: true)
            case .phone:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context, animated: true)
            case .dob:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context, animated: true)
            case .address:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context, animated: true)
            case .citizenship:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context, animated: true)
            case .verifyidentity:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context, animated: true)
            case .ssn:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context)
                gotoSSN(from: context, animated: true)
            case .investingexperience:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context)
                gotoSSN(from: context)
                gotoIExp(from: context, animated: true)
            case .funding:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context)
                gotoSSN(from: context)
                gotoIExp(from: context)
                gotoFundingSource(from: context, animated: true)
            case .employed:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context)
                gotoSSN(from: context)
                gotoIExp(from: context)
                gotoFundingSource(from: context)
                gotoEmployed(from: context, animated: true)
            case .shareholder:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context)
                gotoSSN(from: context)
                gotoIExp(from: context)
                gotoFundingSource(from: context)
                gotoEmployed(from: context)
                gotoShareHolder(from: context, animated: true)
            case .brokerage:
                gotoReferel(from: context)
                gotoName(from: context)
                gotoPhone(from: context)
                gotoDOB(from: context)
                gotoAddress(from: context)
                gotocitizenship(from: context)
                gotoVerify(from: context)
                gotoSSN(from: context)
                gotoIExp(from: context)
                gotoFundingSource(from: context)
                gotoEmployed(from: context)
                gotoShareHolder(from: context)
                gotoBrokerage(from: context, animated: true)
            case .complete:
                gotoUnderReview(from: context)
            default:
                break
            }
        }
    }

    private func gotoReferel(from context: UIViewController, animated: Bool? = false) {
        if let vController = UIStoryboard.main.instantiateViewController(withIdentifier: ReferelCodeVC.identifier) as? ReferelCodeVC {
            vController.delegate = context as? BackPressedDelegte
            context.navigationController?.pushViewController(vController, animated: animated!)
        }
    }
    private func gotoName(from context: UIViewController, animated: Bool? = false) {
        ReferelRouter().route(to: NameVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoPhone(from context: UIViewController, animated: Bool? = false) {
        NameRouter().route(to: PhoneVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoDOB(from context: UIViewController, animated: Bool? = false) {
        PhoneRouter().route(to: DOBVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoAddress(from context: UIViewController, animated: Bool? = false) {
        DOBRouter().route(to: AddressVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotocitizenship(from context: UIViewController, animated: Bool? = false) {
        AddressRouter().route(to: CitizenVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoVerify(from context: UIViewController, animated: Bool? = false) {
        CitizenRouter().route(to: VerifyIdentityVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoSSN(from context: UIViewController, animated: Bool? = false) {
        VidentityRouter().route(to: SocialSecurityVC.identifier, from: context, parameters: nil, animated: animated!)
    }
    private func gotoIExp(from context: UIViewController, animated: Bool? = false) {
        SSNRouter().route(to: InvestingExperienceVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoFundingSource(from context: UIViewController, animated: Bool? = false) {
        IExpRouter().route(to: FundingSourceVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoEmployed(from context: UIViewController, animated: Bool? = false) {
        FundingSourceRouter().route(to: EmployedVC.identifier, from: context, parameters: nil, animated: animated!)
    }
    private func gotoShareHolder(from context: UIViewController, animated: Bool? = false) {
        EmployedRouter().route(to: ShareholderQuestionVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoBrokerage(from context: UIViewController, animated: Bool? = false) {
        ShareHolderRouter().route(to: BrokerageQuestionVC.identifier, from: context, parameters: nil, animated: animated!)
    }

    private func gotoUnderReview(from context: UIViewController) {
        let status = USER.shared.details?.user?.accountStatus?.uppercased()

        switch status {
        case "SUBMITTED":
            UnderRevRouter().route(to: UnderReviewVC.identifier, from: context, parameters: nil, animated: true)
        case "APPROVED":
            ReviewRouter().route(to: AproovedVC.identifier, from: context, parameters: ["approved": true], animated: true)
        default:
            ReviewRouter().route(to: AproovedVC.identifier, from: context, parameters: ["approved": true], animated: true)
        }
    }

    private func openDashboard(from context: UIViewController) {
        if let vController = UIStoryboard.home.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
            UIApplication.setRootView(vController, options: UIApplication.loginAnimation)
        }
    }
}
