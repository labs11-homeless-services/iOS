//
//  CategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import CoreLocation

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    let categoryController = CategoryController()
    let networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Delegate & DataSource
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        networkController.fetchCategoryNames { (error) in

            if let error = error {
                NSLog("Error fetching categories: \(error)")
            }
            DispatchQueue.main.async {
                self.categoriesCollectionView.reloadData()
            }
        }

        networkController.fetchSubcategoryDetails("Shelters") { (error) in
            if let error = error {
                NSLog("Error fetching subcategories: \(error)")
            }
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        let categoryName = networkController.categoryNames[indexPath.row]
        categoryController.tempCategoryName = categoryName
        cell.categoryNameLabel.text = categoryName
        
        categoryController.getIconImage()
        cell.categoryImageView.image = categoryController.iconImage
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryName = networkController.categoryNames[indexPath.row]
        networkController.tempCategorySelection = categoryName
        performSegue(withIdentifier: "modalSubcategoryMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! CategoriesCollectionViewCell
        var categoryIndex = categoriesCollectionView.indexPath(for: cell)
        let destination = segue.destination as! SubcategoriesViewController
        destination.networkController = self.networkController
        //destination.

        
    }
}

//networkController.fetchSubcategoriesNames(SubCategory.shelters)       // Shelters: WORKS!!!!
//networkController.fetchSubcategoriesNames(SubCategory.education)      // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.legal)          // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.food)           // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.healthcare)     // Details: Expected to decode String but found a dictionary instead
//networkController.fetchSubcategoriesNames(SubCategory.outreach)       // Convert from Kebab case
//networkController.fetchSubcategoriesNames(SubCategory.hygiene)        // Phone: Expected to decode Int but found a string/data
//networkController.fetchSubcategoriesNames(SubCategory.jobs)           // Phone: Expected to decode Int but found a string/data
