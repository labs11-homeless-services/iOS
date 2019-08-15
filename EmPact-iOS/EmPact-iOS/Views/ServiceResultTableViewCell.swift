//
//  ServiceResultTableViewCell.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class ServiceResultTableViewCell: UITableViewCell {

    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    @IBOutlet weak var serviceAddressLabel: UILabel!
    @IBOutlet weak var serviceAddressIcon: UIImageView!
    
    @IBOutlet weak var servicePhoneLabel: UILabel!
    @IBOutlet weak var servicePhoneIcon: UIImageView!
    
    @IBOutlet weak var serviceHoursLabel: UILabel!
    @IBOutlet weak var serviceHoursIcon: UIImageView!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    static let reuseIdentifier = "serviceResultCell"
    
    @IBAction func viewButton(_ sender: Any) {
        
    }
}
