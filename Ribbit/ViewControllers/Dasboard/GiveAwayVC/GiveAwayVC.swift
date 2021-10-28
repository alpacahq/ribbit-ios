//
// GiveAwayVC.swift
// Ribbit
//
// Created by Ahsan Ali on 24/03/2021.
//
import UIKit

class GiveAwayVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitle()
    }
    // MARK: - Helpers
    func setupNavTitle() {
        let navigationTitleView: NavigationTitleView = .fromNib()
        navigationTitleView.iconBackTint = .white

        navigationTitleView.titleTint = .white
        self.navigationItem.titleView = navigationTitleView

        let ticketView: TicketView = .fromNib()
        ticketView.backgroundTint = ._B8B7FF
        ticketView.titleTint = ._230B34F
        ticketView.starTint = ._230B34F
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ticketView)
    }
}
extension GiveAwayVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 220 : 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: GiveAwayHeaderCell.identifier) as? GiveAwayHeaderCell else {
                return nil
            }
            return headerCell
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            return 15
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GiveAwayShareCell.identifier) as? GiveAwayShareCell else {
                return UITableViewCell()
            }
            cell.share = {
                if let link = NSURL(string: USER.shared.sharelink) {
                    let objectsToShare = ["Share\nReferrel Code \(USER.shared.code)", link] as [Any]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                    currentController()?.present(activityVC, animated: true, completion: nil)
                }
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCompletedCell.identifier) as? TaskCompletedCell else {
                return UITableViewCell()
            }

            return cell

        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier) as? TaskCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
