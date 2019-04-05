//
//  SubcategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTitleLabel: UIStackView!
    @IBOutlet weak var categoryTitleImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var tempCategorySelection = networkController?.tempCategorySelection
    var selectedCategory = ""
    var networkController: NetworkController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SubcategoriesViewController CategoryNames: \(networkController?.categoryNames)")
        print("SubategoriesViewController tempCategorySelection: \(networkController?.tempCategorySelection)")
        
        networkController?.determineSubcategoryFetch()
        //print("determine: \(networkController?.subcategoryNames)")

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategoryNameCell", for: indexPath) as! SubcategoryTableViewCell
        
        cell.subcategoryNameLabel.text = networkController?.subcategoryNames[indexPath.row].uppercased()
        //cell.subcategoryImageView.image =
        cell.nextArrowImageView.image = UIImage(named: "ic_play_circle_outline")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
