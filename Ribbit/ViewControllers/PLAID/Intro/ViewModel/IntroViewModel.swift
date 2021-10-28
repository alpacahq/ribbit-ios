//
//  IntroViewModel.swift
//  Ribbit
//
//  Created by Ahsan Ali on 19/04/2021.
//

import LinkKit
import UIKit
class IntroViewModel: BaseViewModel, LinkOAuthHandling {
    private(set) var success: Bool! {
        didSet {
            self.bindViewModelToController()
        }
    }

    var linkHandler: Handler?
    var oauthRedirectUri: URL? = { URL(string: "http://localhost:8080") }()

    private var context: UIViewController!
    override init() {
        super.init()
        proxy = NetworkProxy()
        proxy.delegate = self
    }

    // MARK: - Delegate
    override func requestDidBegin() {
        super.requestDidBegin()
    }

    override func requestDidFinishedWithData(data: Any, reqType: RequestType) {
        super.requestDidFinishedWithData(data: data, reqType: reqType)
        switch reqType {
        case .createLinkToken:
            if let token = data as? String {
                presentPlaidLinkUsingLinkToken(linkToken: token, context: self.context)
            }
        default:
            if let msg  = data as? String {
                success = false
                currentController()?.view.makeToast(msg)
            } else {
                success = true
            }
        }
    }

    override func requestDidFailedWithError(error: String, reqType: RequestType) {
        super.requestDidFailedWithError(error: error, reqType: reqType)
        self.bindErrorViewModelToController(error) // If need error in View Controller
    }

    // MARK: - Helper
    func linkBank(context: UIViewController) {
        self.context = context
        proxy.requestForLinkToken()
    }

   private func createLinkTokenConfiguration(linkToken: String) -> LinkTokenConfiguration {
        var linkConfiguration = LinkTokenConfiguration(token: linkToken) { success in
            if let account = success.metadata.accounts.first {
                self.proxy.requestForSetAccessToken(token: success.publicToken, actID: account.id)
            }
        }
        linkConfiguration.onExit = { exit in
            self.success = false
            if let error = exit.error {
                consoleLog("exit with \(error)\n\(exit.metadata)")
            } else {
                consoleLog("exit with \(exit.metadata)")
            }

            self.context.children.first?.dismiss(animated: true)
        }
        return linkConfiguration
    }

    private func presentPlaidLinkUsingLinkToken(linkToken: String, context: UIViewController) {
        let linkConfiguration = createLinkTokenConfiguration(linkToken: linkToken)

        let result = Plaid.create(linkConfiguration)

        switch result {
        case .failure(let error):
            self.success = false
            print("Unable to create Plaid handler due to: \(error)")
        case .success(let handler):

            handler.open(presentUsing: .viewController(context))
            linkHandler = handler
        }
    }
}
