//
//  CategoryController.swift
//  EmPact-iOS
//
//  Created by Jonah Bergevin on 4/4/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoryController {
    
    // MARK: - Properties
    var iconImage: UIImage!
    var subcategoryIconImage: UIImage!
    var tempSubcategoryName: String?

    // MARK: - Methods / Match up Categories & Subcategories with the corresponding images
    func getCategoryImage(from category: String) {
        let imageString = category.split(separator: " ")
        iconImage = UIImage(named: "C-\(imageString[0])")
    }
    
    func getSubcategoryImages() {
        guard let subcategoryName = tempSubcategoryName else { return }
        
        if tempSubcategoryName == "HIV" {
            let imageString = "S-\(subcategoryName)".split(separator: " ").joined()
                   subcategoryIconImage = UIImage(named: imageString)
        } else {
            let imageString = "S-\(subcategoryName)".split(separator: " ").joined().capitalized
            subcategoryIconImage = UIImage(named: imageString)
        }
    }
}

