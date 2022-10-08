//
//  SettingsViewController.swift
//  MarketApp
//
//  Created by Furkan on 3.10.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.title = "Settings"
    }
}
