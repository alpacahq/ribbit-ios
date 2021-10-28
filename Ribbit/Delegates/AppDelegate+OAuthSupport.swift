//
//  AppDelegate+OAuthSupport.swift
//  Ribbit
//
//  Created by Ahsan Ali on 02/04/2021.
//

import LinkKit
import UIKit

extension AppDelegate {
    // MARK: Continue Plaid Link for iOS to complete an OAuth authentication flow
    // <!-- SMARTDOWN_OAUTH_SUPPORT -->
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webpageURL = userActivity.webpageURL else {
            return false
        }

        // Check that the userActivity.webpageURL is the oauthRedirectUri
        // configured in the Plaid dashboard.
        guard let linkOAuthHandler = window?.rootViewController as? LinkOAuthHandling,
            let handler = linkOAuthHandler.linkHandler,
            webpageURL.host == linkOAuthHandler.oauthRedirectUri?.host &&
            webpageURL.path == linkOAuthHandler.oauthRedirectUri?.path
        else {
            return false
        }

        // Continue the Link flow
        handler.continue(from: webpageURL)
        return true
    }
    // <!-- SMARTDOWN_OAUTH_SUPPORT -->

}

protocol LinkOAuthHandling {
    var linkHandler: Handler? { get }
    var oauthRedirectUri: URL? { get }
}
