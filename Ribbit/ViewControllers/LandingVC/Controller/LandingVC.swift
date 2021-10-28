//
//  LandingVC.swift
//  Ribbit
//
//  Created by Adnan Asghar on 3/12/21.

// MARK: - The Purpose of this class is to show the idea of application using SlideView.
import UIKit

class LandingVC: BaseVC {
    // MARK: - IBOutlets
    @IBOutlet var pager: UIPageControl!
    var skinsItems: [LandingPageView] = []
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }

    var currentIndex: Int = 0 {
        didSet {
            pager.currentPage = currentIndex
        }
    }

    // MARK: - Variables
    private var router: LandingRouter!
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        router = LandingRouter()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        skinsItems = LandingPageView.onboardingItems
        pager.numberOfPages = skinsItems.count
        pager.addTarget(self, action: #selector(self.pageControlSelectionAction(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.navigationController?.navigationBar.isHidden = false
    }

    @objc func pageControlSelectionAction(_ sender: UIPageControl) {
        let indexPath = IndexPath(row: sender.currentPage + 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x) / Int(scrollView.frame.width)
        currentIndex = index
    }

    // MARK: - IBActions
    @IBAction func signupPressed(_ sender: UIButton) {
        self.router.routeSignUp(to: SignUpVC.identifier, from: self, parameters: nil, animated: true)
    }
    @IBAction func loginpresswd(_ sender: Any) {
        self.router.route(to: LoginVC.identifier, from: self, parameters: nil, animated: true)
    }
}

// MARK: - UICollection View DataSource
extension LandingVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skinsItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageCell", for: indexPath) as? LandingPageCell ?? LandingPageCell()
        let items = skinsItems[indexPath.row]
        cell.configure(with: items)
        return cell
    }
}
extension LandingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
