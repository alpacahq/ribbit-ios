//
// ProfileDataSource.swift
// Ribbit
//
// Created by Ahsan Ali on 26/04/2021.
//

import Foundation
import ImageLoader
import UIKit
class ProfileTableViewDataSource<CELL: UITableViewCell, T>: NSObject, UITableViewDataSource {
    private var items: [CellType]!

    init(items: [CellType]) {
        self.items = items
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        switch item {
        case .stockHeader:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderCell.identifier) as? ProfileHeaderCell

            cell?.lblBio.text = USER.shared.details?.user?.bio
            let avatar = USER.shared.details?.user?.avatar ?? ""
            cell?.profileImage.load.request(with: avatar, onCompletion: { _, error, _ in
                DispatchQueue.main.async {
                    if error != nil {
                        cell?.profileImage.image = UIImage(named: "Ellipse 8")
                    }
                }
            })

            return cell ?? ProfileHeaderCell()
        case .invite:
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: GiveAwayShareCell.identifier) as? GiveAwayShareCell else {
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
        case .stockSubHeader:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockHeadCell.identifier) as? StockHeadCell else {
                return UITableViewCell()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier) as? StockCell else {
                return UITableViewCell()
            }

            return cell
        }
    }
}
