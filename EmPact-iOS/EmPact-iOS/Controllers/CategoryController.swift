//
//  CategoryController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/4/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoryController {
    
    // MARK: - Properties
    var iconImage: UIImage!
    var subcategoryIconImage: UIImage!
    var tempSubcategoryName: String?
    
    // MARK: - Match up the Categories and Subcategories with the corresponding images
    func getCategoryImage(from category: String) {
        let imageString = category.split(separator: " ")
        iconImage = UIImage(named: "C-\(imageString[0])")
    }
    
    func getSubcategoaryImages() {
        guard let subcategoryName = tempSubcategoryName else { return }
        let imageString = "S-\(subcategoryName)".split(separator: " ").joined()
        subcategoryIconImage = UIImage(named: imageString)
    }
}
