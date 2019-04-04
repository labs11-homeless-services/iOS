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
    
    var iconImage: UIImage!
    var tempCategoryName = ""
    let networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Delegate
        categoriesCollectionView.delegate = self
        
        // Set DataSource
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
        networkController.fetchSubcategoriesNames(SubCategory.shelters)       // Shelters: WORKS!!!!
        //networkController.fetchSubcategoriesNames(SubCategory.education)      // Phone: Expected to decode Int but found a string/data
        //networkController.fetchSubcategoriesNames(SubCategory.legal)          // Phone: Expected to decode Int but found a string/data
        //networkController.fetchSubcategoriesNames(SubCategory.food)           // Phone: Expected to decode Int but found a string/data
        //networkController.fetchSubcategoriesNames(SubCategory.healthcare)     // Details: Expected to decode String but found a dictionary instead
        //networkController.fetchSubcategoriesNames(SubCategory.outreach)       // Convert from Kebab case
        //networkController.fetchSubcategoriesNames(SubCategory.hygiene)        // Phone: Expected to decode Int but found a string/data
        //networkController.fetchSubcategoriesNames(SubCategory.jobs)             // Phone: Expected to decode Int but found a string/data

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        let categoryName = networkController.categoryNames[indexPath.row]
        tempCategoryName = categoryName
        cell.categoryNameLabel.text = categoryName
        
        getIconImage()
        cell.categoryImageView.image = iconImage
        
        return cell
    }
    
    private func getIconImage() -> UIImage {
        
        // Turn this into a for loop/refactor if we have time: Art Gallery project?
        if tempCategoryName == "Shelters" {
            iconImage = UIImage(named: CategoryIconImages.shelter.rawValue)
        } else if tempCategoryName == "Health Care" {
            iconImage = UIImage(named: CategoryIconImages.healthcare.rawValue)
        } else if tempCategoryName == "Food" {
            iconImage = UIImage(named: CategoryIconImages.food.rawValue)
        } else if tempCategoryName == "Hygiene" {
            iconImage = UIImage(named: CategoryIconImages.hygiene.rawValue)
        } else if tempCategoryName == "Outreach Services" {
            iconImage = UIImage(named: CategoryIconImages.outreach.rawValue)
        } else if tempCategoryName == "Education" {
            iconImage = UIImage(named: CategoryIconImages.education.rawValue)
        } else if tempCategoryName == "Legal Administrative" {
            iconImage = UIImage(named: CategoryIconImages.legal.rawValue)
        } else if tempCategoryName == "Jobs" {
            iconImage = UIImage(named: CategoryIconImages.jobs.rawValue)
        }
        
        return iconImage
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
     
     //if categoryName == "Shelters" {
        networkController.fetchSubcategoriesNames(SubCategory.shelters)
     }
     
    }


}
