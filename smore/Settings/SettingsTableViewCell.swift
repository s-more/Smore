//
//  SettingsTableViewCell.swift
//  smore
//
//  Created by Jing Wei Li on 4/23/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "settingsTableViewCell"
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var serviceToggle: UISwitch!
    
    private var service: StreamingService = .none
    
    var didToggleService: ((StreamingService, Int) -> Void)?
    var index = 0
    
    func configure(with service: StreamingService, index: Int) {
        serviceImageView.image = service.icon
        titleLabel.text = service.name
        serviceToggle.isOn = service.isServiceEnabled
        self.service = service
        self.index = index
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func toggled(_ sender: UISwitch) {
        service.toggleServiceEnabled()
        didToggleService?(service, index)
    }
    
}
