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
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var homeLabelStackView: UIStackView!
    @IBOutlet weak var homeButtonText: UIButton!
    
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryTitleImage: UIImageView!
    @IBOutlet weak var hamburgerSideButton: UIButton!
    
    @IBOutlet var hamburgerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
//    @IBAction func unwindToSubcategoriesVC(segue:UIStoryboardSegue) {
//    
//    }
    
    @IBAction func homeButton(_ sender: Any) {
    }
    
    var selectedCategory: String!

    var googleMapsController: GoogleMapsController?
    var networkController: NetworkController?
    
    var categoryController = CategoryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheme()
        
        if selectedCategory == "Outreach Services" {
            categoryTitleLabel.text = "OUTREACH"
        } else if selectedCategory == "Legal Administrative" {
            categoryTitleLabel.text = "LEGAL"
        } else {
            categoryTitleLabel.text = selectedCategory.uppercased()
        }

        categoryTitleLabel.adjustsFontSizeToFitWidth = true
        
        categoryController.getIconImage(from: selectedCategory)
        categoryTitleImage.image = categoryController.iconImage
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(Category(rawValue: selectedCategory.lowercased()))
       
        if selectedCategory.lowercased() == "health care" || selectedCategory.lowercased() == "legal administrative" || selectedCategory.lowercased() == "outreach services" {
            
            guard let underscoredPassedCategory = UnderscoredCategory(rawValue: selectedCategory.lowercased()) else { return }
            networkController?.fetchSubcategoriesUnderscoredNames(underscoredPassedCategory, completion: { ([String], error) in
                if let error = error {
                    NSLog("Error fetching underscored categories: \(error)")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            })
            
        } else {
            guard let passedCategory = Category(rawValue: selectedCategory.lowercased()) else { return }
            if networkController?.subcategoryNames.count ?? 0 < 1 {
                print("selectedCategory: \(selectedCategory)")
                print("selectedCategory lowercased: \(selectedCategory.lowercased())")
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

        hamburgerSideButton.backgroundColor = UIColor.clear
        hamburgerView.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController?.subcategoryNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcategoryNameCell", for: indexPath) as! SubcategoryTableViewCell
        
        guard let subcategory = networkController?.subcategoryNames[indexPath.row] else { fatalError("Unable to unwrap the subcategories and sort them") }
        
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
        print("tempSubcategorySelection: \(networkController?.tempSubcategorySelection)")
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
    var interactor:Interactor? = nil
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
    
    // MARK: - Theme
    
    func setupTheme() {
        
        // Spanish Button
        spanishButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        spanishButton.setTitle("Español", for: .normal)
        spanishButton.setTitleColor(.customDarkPurple, for: .normal)
        spanishButton.backgroundColor = .white
        spanishView.backgroundColor = .customDarkPurple
        spanishButton.layer.cornerRadius = 5
        spanishButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        let tapColoredIcon = UIImage(named: "tap")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        spanishButton.tintColor = .customDarkPurple
        spanishButton.setImage(tapColoredIcon, for: .normal)
        
        // Home Button
        //homeLabelStackView.backgroundColor = UIColor.white
        homeView.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        homeButton.backgroundColor = UIColor.white
        homeButton.tintColor = UIColor.white
        homeButtonText.backgroundColor = UIColor.white
        homeButtonText.tintColor = UIColor.customDarkPurple
        
//        homeButton.setTitle("HOME", for: .normal)
//        homeButton.setTitleColor(.customDarkPurple, for: .normal)
//        homeButton.backgroundColor = .white
        
        let homeColoredIcon = UIImage(named: "home")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)

        homeButton.tintColor = .customDarkPurple
        homeButton.setImage(homeColoredIcon, for: .normal)
        
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
        //categoryTitleLabel.font = Appearance.boldFont
        
        subcategoryLabel.textColor = UIColor.customLightPurple
    }
    
}
