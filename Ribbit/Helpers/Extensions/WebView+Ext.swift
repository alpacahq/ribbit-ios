//
//  WebView.swift
//  Ribbit
//
//  Created by Rao Mudassar on 18/07/2021.
//

import Foundation
import WebKit

extension WKWebView {
    func didScrollEnd(completion: @escaping (_ isScrolledAtBottom: Bool, _ isScrollAtTop: Bool) -> Void) {
        self.evaluateJavaScript("document.readyState", completionHandler: { complete, error in
            if complete != nil {
                self.evaluateJavaScript("document.body.scrollHeight", completionHandler: { height, _ in
                    let bodyScrollHeight = height as? CGFloat
                    var bodyoffsetheight: CGFloat = 0
                    var htmloffsetheight: CGFloat = 0
                    var htmlclientheight: CGFloat = 0
                    var htmlscrollheight: CGFloat = 0
                    var wininnerheight: CGFloat = 0
                    var winpageoffset: CGFloat = 0
                    var winheight: CGFloat = 0

                    // body.offsetHeight
                    self.evaluateJavaScript("document.body.offsetHeight", completionHandler: { offsetHeight, _ in
                        bodyoffsetheight = offsetHeight as? CGFloat ?? 0.0

                        self.evaluateJavaScript("document.documentElement.offsetHeight", completionHandler: { offsetHeight, _ in
                            htmloffsetheight = offsetHeight as? CGFloat ?? 0.0

                            self.evaluateJavaScript("document.documentElement.clientHeight", completionHandler: { clientHeight, _ in
                                htmlclientheight = clientHeight as? CGFloat ?? 0.0

                                self.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { scrollHeight, _ in
                                    htmlscrollheight = scrollHeight as? CGFloat ?? 0.0

                                    self.evaluateJavaScript("window.innerHeight", completionHandler: { winHeight, error in
                                        if error != nil {
                                            wininnerheight = -1
                                        } else {
                                            wininnerheight = winHeight as? CGFloat ?? 0.0
                                        }

                                        self.evaluateJavaScript("window.pageYOffset", completionHandler: { winpageOffset, _ in
                                            winpageoffset = winpageOffset as? CGFloat ?? 0.0

                                            let docHeight = max(bodyScrollHeight ?? 0, bodyoffsetheight, htmlclientheight, htmlscrollheight, htmloffsetheight)

                                            winheight = wininnerheight >= 0 ? wininnerheight : htmloffsetheight
                                            let winBottom = winheight + winpageoffset
                                            if winBottom >= docHeight {
                                                completion(true, false)
                                            } else if winpageoffset == 0 {
                                                completion(false, true)
                                            }
                                        })
                                    })
                                })
                            })
                        })
                    })
                })
            }
        })
    }
}
