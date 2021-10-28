//
// NotificationsVC.swift
// Ribbit
//
// Created by Ahsan Ali on 31/05/2021.
//
import UIKit
class NotificationsVC: UIViewController {
    // MARK: - Ouletlets
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    // MARK: - Vars

    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitle()
    }

    func setupNavTitle() {
        let navigationTitleView: NavigationTitleView = .fromNib()
        self.navigationItem.titleView = navigationTitleView
        let ticketView: TicketView = .fromNib()
        ticketView.backgroundTint = ._FFE68B
        ticketView.titleTint = ._230B34F
        ticketView.starTint = ._230B34F
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ticketView)
    }
}
extension NotificationsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier) as? NotificationCell ?? NotificationCell()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? NotificationCell ?? NotificationCell()
        cell.contentView.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 1, alpha: 1)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? NotificationCell ?? NotificationCell()
        cell.contentView.backgroundColor = .white
    }
}
