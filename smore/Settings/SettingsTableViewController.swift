//
//  SettingsTableViewController.swift
//  smore
//
//  Created by Jing Wei Li on 4/23/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    let services: [StreamingService] = [.appleMusic, .spotify, .youtube]
    
    init() {
        super.init(nibName: "SettingsTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: Bundle.main),
                           forCellReuseIdentifier: SettingsTableViewCell.identifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Toggle Services"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier,
                                                 for: indexPath)
        
        if let cell = cell as? SettingsTableViewCell {
            cell.configure(with: services[indexPath.row], index: indexPath.row)
            cell.didToggleService = didToggleService(_:index:)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    private func showRestartAlert() {
        UIAlertController.showGenericAlert(
            title: "Restart",
            subtitle: "Restart the app to activiate these changes",
            on: self)
    }
    
    private func didToggleService(_ service: StreamingService, index: Int) {
        guard FeatureFlags.atLeastOneServiceEnabled else {
            service.toggleServiceEnabled()
            (tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                as? SettingsTableViewCell)?.serviceToggle.isOn = true
            UIAlertController.showGenericAlert(
                title: "Error",
                subtitle: "One streaming service must be enabled    ",
                on: self)
            return
        }
        switch service {
        case .appleMusic:
            if service.isServiceEnabled {
               // enable the service for the first time
                AppleMusicAPI.authrozeAndRequestUserToken(success: { [weak self] in
                    self?.showRestartAlert()
                }, error: { [weak self] error in
                    guard let strongSelf = self else { return }
                    UIAlertController.showGenericAlert(
                        title: "Error",
                        subtitle: error.localizedDescription,
                        on: strongSelf)
                    service.toggleServiceEnabled()
                    (strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                        as? SettingsTableViewCell)?.serviceToggle.isOn = false
                })
            } else {
                showRestartAlert()
            }
        default:
            showRestartAlert()
        }
    }
    
}
