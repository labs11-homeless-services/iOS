//
//  SubcategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var spanishView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryTitleImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
//    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
//        networkController?.subcategoryNames = []
//        networkController?.subcategoryDetails = []
//        dismiss(animated: true, completion: nil)
//    } // We might need to rename this.
    
    var selectedCategory: String!

    var networkController: NetworkController?
    
    var categoryController = CategoryController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(Category(rawValue: selectedCategory.lowercased()))
       
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
        
        setupTheme()
        
        categoryTitleLabel.text = selectedCategory
        
        categoryController.getIconImage(from: selectedCategory)
        categoryTitleImage.image = categoryController.iconImage

        //networkController?.fetchSubcategoryDetails(.all)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }
    
    func setupTheme() {
        
        // Spanish Button
        spanishButton.setTitle("Español", for: .normal)
        spanishButton.setTitleColor(.customDarkPurple, for: .normal)
        spanishButton.backgroundColor = .white
        spanishView.backgroundColor = .customDarkPurple
        spanishButton.layer.cornerRadius = 5
        
        let tapColoredIcon = UIImage(named: "tap")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        spanishButton.tintColor = .customDarkPurple
        spanishButton.setImage(tapColoredIcon, for: .normal)
        
        topView.backgroundColor = UIColor.customDarkPurple
        homeButton.backgroundColor = UIColor.white
        homeButton.tintColor = UIColor.customDarkPurple
        
        categoryTitleLabel.textColor = .white
        categoryTitleLabel.font = Appearance.boldFont
        
        subcategoryLabel.textColor = UIColor.customLightPurple
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategoryNameCell", for: indexPath) as! SubcategoryTableViewCell
        

        guard let subcategory = networkController?.subcategoryNames[indexPath.row] else { fatalError("Unable to unwrap the subcategories and sort them") }
        //.sorted(by: { $0 < $1 })
        cell.subcategoryNameLabel.text = String(subcategory).capitalized
        cell.subcategoryNameLabel.textColor = .customDarkGray
        
        categoryController.tempSubcategoryName = subcategory
        
        categoryController.getSubcategoryIconImage()
        cell.subcategoryImageView.image = categoryController.subcategoryIconImage

        let coloredIcon = UIImage(named: "right_arrow")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        cell.nextArrowImageView.tintColor = .customDarkGray
        
        cell.nextArrowImageView.image = coloredIcon

        cell.cellView.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 1)
        cell.cellView.layer.addBorder(edge: .bottom, color: UIColor.lightGray, thickness: 1)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let subcategoryAtIndexPath = networkController?.subcategoryNames[indexPath.row] else { return }
        
        networkController?.tempSubcategorySelection = subcategoryAtIndexPath
        networkController?.determineSubcategoryDetailFetch()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "showResults" {
            guard let navController = segue.destination as? UINavigationController,
            let destination = navController.viewControllers[0] as? ServiceResultsViewController,
      
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let subcategoryDetails = networkController?.subcategoryNames[indexPath.row]
        
            destination.networkController = networkController
            destination.selectedSubcategory = subcategoryDetails
        }
    }
    
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
