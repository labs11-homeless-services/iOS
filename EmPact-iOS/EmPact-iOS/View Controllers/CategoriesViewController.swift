//
//  CategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var categoriesScrollView: UIScrollView!
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    //let networkController = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NetworkController.fetchCategoryNames()
        //NetworkController.fetchCategoriesFromServer()

        // Set Delegate
        categoriesCollectionView.delegate = self
        
        // Set DataSource
        categoriesCollectionView.dataSource = self
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NetworkController.fetchCategoryNames()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NetworkController.shared.categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoriesCollectionViewCell
        
        let categoryName = NetworkController.shared.categoryNames[indexPath.row]
        cell.categoryNameLabel.text = categoryName
        //cell.categoryImageView.image =
        
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
