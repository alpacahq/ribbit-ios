//
// MyRewardsVC.swift
// Ribbit
//
// Created by Ahsan Ali on 25/03/2021.
//
import FittedSheets
import UIKit
class MyRewardsVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var rewardCV: UICollectionView!
    @IBOutlet var rewardPopUp: RewardPopUpView!

    // MARK: - Vars
    private var cellTypes: [CellType] = [.reward, .reward, .reward, .scratch, .reward]

    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitle()
    }
    // MARK: - Helpers
    func setupNavTitle() {
        let navigationTitleView: NavigationTitleView = .fromNib()
        navigationTitleView.iconBackTint = ._854537

        navigationTitleView.titleTint = .white
        self.navigationItem.titleView = navigationTitleView

        let ticketView: TicketView = .fromNib()
        ticketView.backgroundTint = ._FFE68B
        ticketView.titleTint = ._230B34F
        ticketView.starTint = ._230B34F
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ticketView)
    }
}
extension MyRewardsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: RewardHeaderView!

        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: RewardHeaderView.identifier, for: indexPath)
                as? RewardHeaderView
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.42
        return CGSize(width: width, height: width)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellTypes[indexPath.row] == .reward {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardCell.identifier, for: indexPath) as? RewardCell ?? RewardCell()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScratchCell.identifier, for: indexPath) as? ScratchCell ?? ScratchCell()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cellTypes[indexPath.item] == .scratch {
            rewardPopUp.isHidden = false
            rewardPopUp.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            UIApplication.shared.windows.first!.addSubview(rewardPopUp)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
