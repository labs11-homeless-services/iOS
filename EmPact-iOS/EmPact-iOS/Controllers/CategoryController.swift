//
//  CategoryController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/4/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoryController {
    
    var iconImage: UIImage!
    
    var tempCategoryName = ""
    
    func getIconImage() -> UIImage {
        
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
}
