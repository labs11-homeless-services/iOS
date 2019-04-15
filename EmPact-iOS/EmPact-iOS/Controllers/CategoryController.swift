//
//  CategoryController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/4/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoryController {
    
    var networkController = NetworkController()
    var iconImage: UIImage!
    var subcategoryIconImage: UIImage!
    //var tempCategoryName = ""
    var tempSubcategoryName = ""

    func getIconImage(from category: String) {
        
        if category == "Shelters" {
            iconImage = UIImage(named: CategoryIconImages.shelter.rawValue)
        } else if category == "Health Care" {
            iconImage = UIImage(named: CategoryIconImages.healthcare.rawValue)
        } else if category == "Food" {
            iconImage = UIImage(named: CategoryIconImages.food.rawValue)
        } else if category == "Hygiene" {
            iconImage = UIImage(named: CategoryIconImages.hygiene.rawValue)
        } else if category == "Outreach Services" {
            iconImage = UIImage(named: CategoryIconImages.outreach.rawValue)
        } else if category == "Education" {
            iconImage = UIImage(named: CategoryIconImages.education.rawValue)
        } else if category == "Legal Administrative" {
            iconImage = UIImage(named: CategoryIconImages.legal.rawValue)
        } else if category == "Jobs" {
            iconImage = UIImage(named: CategoryIconImages.jobs.rawValue)
        }
    }
    
    func getSubcategoryIconImage() {
        
        if tempSubcategoryName == "men" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.men.rawValue)
        } else if tempSubcategoryName == "women" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.women.rawValue)
        } else if tempSubcategoryName == "youth" {
            subcategoryIconImage = UIImage(named: "S-church")
        } else if tempSubcategoryName == "all" {
            subcategoryIconImage = UIImage(named: "S-church")
        } else if tempSubcategoryName == "ged" {
            subcategoryIconImage = UIImage(named: "C-outreach-services")
        } else if tempSubcategoryName == "publicComputers" {
            subcategoryIconImage = UIImage(named: "S-church")
        } else if tempSubcategoryName == "foodPantries" {
            subcategoryIconImage = UIImage(named: "C-food")
        } else if tempSubcategoryName == "foodStamps" {
            subcategoryIconImage = UIImage(named: "C-food")
        } else if tempSubcategoryName == "clinics" {
            subcategoryIconImage = UIImage(named: "C-health-care")
        } else if tempSubcategoryName == "emergency" {
            subcategoryIconImage = UIImage(named: "C-emergency")
        } else if tempSubcategoryName == "hiv" {
            subcategoryIconImage = UIImage(named: "C-health-care")
        } else if tempSubcategoryName == "mentalHealth" {
            subcategoryIconImage = UIImage(named: "C-jobs")
        } else if tempSubcategoryName == "rehab" {
            subcategoryIconImage = UIImage(named: "S-drugs")
        } else if tempSubcategoryName == "bathrooms" {
            subcategoryIconImage = UIImage(named: "C-hygiene")
        } else if tempSubcategoryName == "showers" {
            subcategoryIconImage = UIImage(named: "C-hygiene")
        } else if tempSubcategoryName == "benefits" {
            subcategoryIconImage = UIImage(named: "C-jobs")
        } else if tempSubcategoryName == "afterSchool" {
            subcategoryIconImage = UIImage(named: "C-outreach-services")
        } else if tempSubcategoryName == "domesticViolence" {
            subcategoryIconImage = UIImage(named: "S-abuse")
        } else if tempSubcategoryName == "socialServices" {
            subcategoryIconImage = UIImage(named: "C-outreach-services")
        }
    }
}
