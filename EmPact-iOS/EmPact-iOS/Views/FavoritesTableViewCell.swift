//
//  FavoritesTableViewCell.swift
//  EmPact-iOS
//
//  Created by Jonah  on 6/24/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteName: UILabel!
    @IBOutlet weak var favoriteAddressLabel: UILabel!
    @IBOutlet weak var favoritePhoneLabel: UILabel!
    @IBOutlet weak var favoriteHoursLabel: UILabel!
    
    static let reuseIdentifier = "FavoritesCell"
}
