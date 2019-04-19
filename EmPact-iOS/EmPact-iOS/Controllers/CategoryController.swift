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
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.youth.rawValue)
        } else if tempSubcategoryName == "all" {
            subcategoryIconImage = UIImage(named: "S-church")
        } else if tempSubcategoryName == "ged" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.ged.rawValue)
        } else if tempSubcategoryName == "public computers" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.publicComputers.rawValue)
        } else if tempSubcategoryName == "food pantries" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.foodPantries.rawValue)
        } else if tempSubcategoryName == "food stamps" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.foodStamps.rawValue)
        } else if tempSubcategoryName == "clinics" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.clinics.rawValue)
        } else if tempSubcategoryName == "emergency" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.emergency.rawValue)
        } else if tempSubcategoryName == "hiv" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.hiv.rawValue)
        } else if tempSubcategoryName == "mental health" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.mentalHealth.rawValue)
        } else if tempSubcategoryName == "rehab" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.rehab.rawValue)
        } else if tempSubcategoryName == "bathrooms" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.bathrooms.rawValue)
        } else if tempSubcategoryName == "showers" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.showers.rawValue)
        } else if tempSubcategoryName == "benefits" {
            subcategoryIconImage = UIImage(named: "C-jobs")
        } else if tempSubcategoryName == "after school" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.afterSchool.rawValue)
        } else if tempSubcategoryName == "domestic violence" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.domesticViolence.rawValue)
        } else if tempSubcategoryName == "social services" {
            subcategoryIconImage = UIImage(named: SubcategoryIconImages.socialServices.rawValue)
        }
    }
}
