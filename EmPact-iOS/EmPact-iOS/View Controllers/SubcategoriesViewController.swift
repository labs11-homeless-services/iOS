//
//  SubcategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: String!
    var networkController: NetworkController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Passed Category is instantiated as a subCategory enum and lowercased to match the rawvalue
        guard let passedCategory = SubCategory(rawValue: selectedCategory.lowercased()) else { return }
        
        networkController?.fetchSubcategoriesNames(passedCategory, completion: { ([String], error) in
            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        var tempSelectedCategory = networkController?.tempCategorySelection
        print("Temp Variables: \(tempSelectedCategory) \(selectedCategory)")
        
        //categoryTitleImage.image = get this image
        //categoryTitleLabel.text = selectedCategory
        
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
       
        guard let destination = segue.destination as? ServiceResultsViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let subcategoryDetails = networkController?.subcategoryNames[indexPath.row]
        
        destination.networkController = networkController
        destination.selectedSubcategory = subcategoryDetails
    }
    
    
}
