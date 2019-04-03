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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return networkController.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoriesCollectionViewCell
        
        let categoryName = networkController.categoryNames[indexPath.row]
        cell.categoryNameLabel.text = categoryName
        
        var iconImage: UIImage!
        if categoryName == "Shelters" {
            iconImage = UIImage(named: CategoryIconImages.shelter.rawValue)
        } else if categoryName == "Health Care" {
            iconImage = UIImage(named: CategoryIconImages.healthcare.rawValue)
        } else if categoryName == "Food" {
            iconImage = UIImage(named: CategoryIconImages.food.rawValue)
        } else if categoryName == "Hygiene" {
            iconImage = UIImage(named: CategoryIconImages.hygiene.rawValue)
        } else if categoryName == "Outreach Services" {
            iconImage = UIImage(named: CategoryIconImages.outreach.rawValue)
        } else if categoryName == "Education" {
            iconImage = UIImage(named: CategoryIconImages.education.rawValue)
        } else if categoryName == "Legal Administrative" {
            iconImage = UIImage(named: CategoryIconImages.legal.rawValue)
        } else if categoryName == "Jobs" {
            iconImage = UIImage(named: CategoryIconImages.jobs.rawValue)
        }
        
        cell.categoryImageView.image = iconImage
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
