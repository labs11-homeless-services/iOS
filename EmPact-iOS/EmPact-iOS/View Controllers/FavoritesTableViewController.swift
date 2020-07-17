//
//  FavoritesTableViewController.swift
//  EmPact-iOS
//
//  Created by Jonah  on 6/22/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

    var favoritesArray: [SimpleResource] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var favoritesWithoutDuplicates: [SimpleResource] = []
    var savedItem: IndividualResource?
    var cacheController: CacheController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let cacheController = cacheController else { return }
        favoritesArray = cacheController.loadFavorites()
        print("Faves Array \(favoritesArray)")
        tableView.reloadData()
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseIdentifier, for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }

        let favorite = favoritesArray[indexPath.row]
        
        cell.favoriteName.text = favorite.name
        cell.favoriteAddressLabel.text = favorite.address
        cell.favoritePhoneLabel.text = favorite.phone
        cell.favoriteHoursLabel.text = favorite.hours
        
        return cell
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let favorite = favoritesArray[indexPath.row]
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedToDetailsVC" {
            guard let savedVC = segue.destination as? FavoritesDetailViewController,
            
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let savedDetail = cacheController?.savedResources[indexPath.row]
                savedVC.cacheController = cacheController
                savedVC.savedResource = savedDetail
            
        }
    }
    
}
