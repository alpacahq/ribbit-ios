//
//  ReviewVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/17/21.

// MARK: - Review Terms & Conditions.

import Alamofire
import SSSpinnerButton
import UIKit
import WebKit

class ReviewVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet var btnContinue: SSSpinnerButton!
    @IBOutlet var webView: WKWebView!

    // MARK: - Variables
    private var reviewViewModel: ReviewViewModel!
    private let router = ReviewRouter()

    var sView = UIView()
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewViewModel = ReviewViewModel()
        sView = ReviewVC.displaySpinner(onView: self.view)
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        let url = URL(string: EndPoint.kServerBase + "template/terms_conditions.html")!
        webView.contentMode = .scaleToFill
        webView.load(URLRequest(url: url))
        self.btnContinue.setTitle("Review", for: .normal)
    }
    // MARK: - IBActions
    @IBAction func submitPressed(_ sender: SSSpinnerButton) {
        if self.btnContinue.titleLabel?.text == "Review" {
            self.btnContinue.setTitle("Submit", for: .normal)
            var scrollHeight: CGFloat = webView.scrollView.contentSize.height - webView.bounds.size.height
            if 0.0 > scrollHeight {
                scrollHeight = 0.0
            }
            webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: scrollHeight), animated: true)
        } else {
            self.reviewViewModel.sign()
            sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
                self.reviewViewModel.sender = sender
            })
            reviewViewModel.bindErrorViewModelToController = { error in
                self.view.makeToast(error)
                sender.stopAnimate(complete: nil)
            }
            reviewViewModel.bindViewModelToController = {
                sender.stopAnimate {
                    let status = USER.shared.details?.user?.accountStatus?.uppercased()
                    switch status {
                    case "SUBMITTED":
                        self.router.route(to: UnderReviewVC.identifier, from: self, parameters: nil, animated: true)
                    case "APPROVED":
                        self.router.route(to: AproovedVC.identifier, from: self, parameters: ["approved": true], animated: true)
                    default:
                        self.router.route(to: AproovedVC.identifier, from: self, parameters: ["approved": false], animated: true)
                    }
                }
            }
        }
    }
    @IBAction func startOverPressed(_ sender: SSSpinnerButton) {
        sender.startAnimate(spinnerType: SpinnerType.circleStrokeSpin, spinnercolor: UIColor.white, spinnerSize: 20, complete: {
            self.reviewViewModel.sender = sender
            self.reviewViewModel.startOver()
            self.reviewViewModel.bindStartOverViewModelToController = {
                self.router.route(to: EmailVC.identifier, from: self, parameters: nil, animated: true)
            }
        })
    }
}

// MARK: - Webview delegate and scroll delegate.

extension ReviewVC: WKNavigationDelegate, UIScrollViewDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start Request")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ReviewVC.removeSpinner(spinner: sView)
        print("Failed Request")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ReviewVC.removeSpinner(spinner: sView)
        print("Finished Request")
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            self.stoppedScrolling()
        }
        if scrollView.contentOffset.y <= 0 {
        }
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) {
        }
    }
    func stoppedScrolling() {
        self.btnContinue.setTitle("Submit", for: .normal)
    }
}
extension ReviewVC {
    class func displaySpinner(onView: UIView) -> UIView {
        let spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let aiV = UIActivityIndicatorView(style: .large)
        aiV.startAnimating()
        aiV.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(aiV)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    class func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
