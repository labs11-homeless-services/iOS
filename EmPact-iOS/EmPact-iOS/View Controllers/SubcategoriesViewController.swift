//
//  SubcategoriesViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class SubcategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var closeLabel: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryTitleImage: UIImageView!
    @IBOutlet weak var hamburgerSideButton: UIButton!
    
    @IBOutlet var hamburgerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory: String!
    
    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    var categoryController = CategoryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheme()
        capitalize()

        categoryTitleLabel.adjustsFontSizeToFitWidth = true
        
        categoryController.getCategoryImage(from: selectedCategory)
        categoryTitleImage.image = categoryController.iconImage
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        guard let passedCategory = Category(rawValue: selectedCategory.lowercased()) else { return }
        if networkController?.subcategoryNames.count ?? 0 < 1 {
            networkController?.fetchSubcategoriesNames(passedCategory, completion: { (_: [String], error) in
                if let error = error {
                    NSLog("Error fetching categories: \(error)")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            })
        }

        hamburgerSideButton.backgroundColor = UIColor.clear
        hamburgerView.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategoryNameCell", for: indexPath) as! SubcategoryTableViewCell
        
        guard let subcategory = networkController?.subcategoryNames[indexPath.row] else { fatalError("Unable to unwrap the subcategories and sort them") }
        cell.subcategoryNameLabel.text = String(subcategory)
        cell.subcategoryNameLabel.textColor = .customDarkGray
        
        categoryController.tempSubcategoryName = subcategory
        categoryController.getSubcategoryImages()
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
        networkController?.subcategoryDetails = []
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "showResults" {
            guard let navController = segue.destination as? UINavigationController,
            let destination = navController.viewControllers[0] as? ServiceResultsViewController,
      
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let subcategoryDetails = networkController?.subcategoryNames[indexPath.row]
        
            destination.googleMapsController = googleMapsController
            destination.networkController = networkController
            destination.selectedSubcategory = subcategoryDetails
        }
    }
    
    @IBAction func spanishButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "La traducción al español vendrá pronto.", message: "Spanish translation coming soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Hamburger Menu Actions
    @IBAction func closeMenu(_ sender: Any) {
        networkController?.subcategoryNames = []
        dismiss(animated: true, completion: nil)
        networkController?.subcategoryNames = []
    }
    // MARK: - Hamburger Menu Variables
    var interactor: Interactor? = nil
    var menuActionDelegate:MenuActionDelegate? = nil
    
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
    
    private func capitalize() {
        if selectedCategory == "Outreach Services" {
            categoryTitleLabel.text = "OUTREACH"
        } else if selectedCategory == "Legal Administrative" {
            categoryTitleLabel.text = "LEGAL"
        } else {
            categoryTitleLabel.text = selectedCategory.uppercased()
        }
    }
    
    // MARK: - Theme
    func setupTheme() {
        // Close Button
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .customDarkPurple
        
        let closeColoredIcon = UIImage(named: "Sharp")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        closeButton.tintColor = .white
        closeButton.setImage(closeColoredIcon, for: .normal)
        closeLabel.backgroundColor = .customDarkPurple
        closeLabel.textColor = .white
        // Top Bar
        topView.backgroundColor = UIColor.customDarkPurple
        categoryTitleLabel.textColor = .white
        subcategoryLabel.textColor = UIColor.customLightPurple
    }
}

