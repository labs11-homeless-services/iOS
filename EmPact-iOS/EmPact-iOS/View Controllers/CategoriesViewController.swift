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
        
        print("CategoriesViewController CategoryNames: \(networkController.categoryNames)")
        print("CategoriesViewController tempCategorySelection: \(networkController.tempCategorySelection)")
  
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        let category = networkController.categoryNames[indexPath.row]
        categoryController.tempCategoryName = category
        cell.categoryNameLabel.text = category
        
        categoryController.getIconImage()
        cell.categoryImageView.image = categoryController.iconImage
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let categoryAtIndexPath = networkController.categoryNames[indexPath.row]
        networkController.tempCategorySelection = categoryAtIndexPath

        performSegue(withIdentifier: "modalSubcategoryMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destination = segue.destination as! SubcategoriesViewController
        destination.networkController = networkController
        destination.selectedCategory = networkController.tempCategorySelection
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
