//
//  SubcategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //@IBOutlet weak var topView: UIView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryTitleImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: String!

    var networkController: NetworkController?
    
    var categoryController = CategoryController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        guard let passedCategory = Category(rawValue: selectedCategory.lowercased()) else { return }
        if networkController?.subcategoryNames.count ?? 0 < 1 {
            networkController?.fetchSubcategoriesNames(passedCategory, completion: { ([String], error) in
                if let error = error {
                    NSLog("Error fetching categories: \(error)")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()

                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTitleLabel.text = selectedCategory
        
        //networkController?.fetchSubcategoryDetails(.all)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategoryNameCell", for: indexPath) as! SubcategoryTableViewCell
        
        cell.subcategoryNameLabel.text = networkController?.subcategoryNames[indexPath.row].capitalized
        //cell.subcategoryImageView.image =
        cell.nextArrowImageView.image = UIImage(named: "ic_play_circle_outline")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let subcategoryAtIndexPath = networkController?.subcategoryNames[indexPath.row] else { return }
        
        networkController?.tempSubcategorySelection = subcategoryAtIndexPath
    
        networkController?.determineSubcategoryDetailFetch()
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let destination = segue.destination as? ServiceResultsViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let subcategoryDetails = networkController?.subcategoryNames[indexPath.row]
        
        destination.networkController = networkController
        destination.selectedSubcategory = subcategoryDetails
    }
    
    // MARK: - Hamburger Menu Outlets
    // MARK: - Hamburger Menu Actions
    @IBAction func closeMenu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        networkController?.subcategoryNames = []
    }
    
    // MARK: - Hamburger Menu Variables
    var interactor:Interactor? = nil
    var menuActionDelegate:MenuActionDelegate? = nil
    let menuItems = ["First", "Second"]
    
    // MARK: - Hamburger Menu Methods
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        dismiss(animated: true){
            self.delay(seconds: 0.5){
                self.menuActionDelegate?.reopenMenu()
            }
        }
    }
    
    
}
