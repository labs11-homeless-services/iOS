//
//  SearchResultsTableViewCell.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/23/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var searchResultsView: UIView!
    @IBOutlet weak var searchResultNameLabel: UILabel!
    
    @IBOutlet weak var addressIconImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneIconImage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var hoursIconImage: UIImageView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var hoursView: UIView!
    
    static let reuseIdentifier = "searchResultCell"
}
