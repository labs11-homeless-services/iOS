//
//  LanguageSelectionViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var navBarExtensionView: UIView!
    @IBOutlet weak var searchTagLineLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //let googleMapsController = GoogleMapsController()
    
    let networkController = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        
        // Set Delegate
        searchBar.delegate = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTheme()
        
        setupViews()

        // Add title logo
        let logoImage = UIImage(named: "iPhone logo Nu")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        self.navigationItem.titleView = titleView
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        searchBar.text = ""
        
        setupTheme()
        
        setupViews()
    }

    
    @IBAction func englishButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func espanolButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "La traducción al español vendrá pronto.", message: "Spanish translation coming soon.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - UI Search Bar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        filterServiceResults()
        
        performSegue(withIdentifier: "showSearchResults", sender: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterServiceResults() {
        // Grab the text, make sure it's not empty
        
        guard let searchTerm = self.searchBar.text, !searchTerm.isEmpty else {
            return
        }
        
        networkController.searchTerm = searchTerm
        
        let matchingObjects = NetworkController.filteredObjects.filter({ $0.keywords.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.lowercased()) })
        
        networkController.subcategoryDetails = matchingObjects
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showSearchResults" {
            let destination = segue.destination as! SearchResultsViewController
            destination.networkController = networkController
            //destination.googleMapsController = googleMapsController
        } else {
            let destination = segue.destination as! CategoriesViewController
            destination.networkController = networkController
        }
        
//        if segue.identifier == "landingToServiceResultsSegue" {
//            let destination = segue.destination as! ServiceResultsViewController
//            destination.networkController = networkController
//        } else {
//            let destination = segue.destination as! CategoriesViewController
//            destination.networkController = networkController
//        }

    }
    
    func setupViews() {
        
        navBarExtensionView.backgroundColor = .customDarkPurple
        navBarExtensionView.layer.cornerRadius = 16
        navBarExtensionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setupTheme() {

        // Set background color to custom purple with no transparency
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .customDarkPurple
        
        // Remove bottom border from navigation bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()

        searchTagLineLabel.textColor = .customDarkPurple
        
        let tapColoredIcon = UIImage(named: "tap")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        englishButton.setTitle("English  ", for: .normal)
        englishButton.backgroundColor = .customDarkPurple
        englishButton.tintColor = .white
        englishButton.setImage(tapColoredIcon, for: .normal)
        englishButton.layer.cornerRadius = 5
        englishButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        englishButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        englishButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        englishButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
        
        spanishButton.setTitle("Español  ", for: .normal)
        spanishButton.backgroundColor = .customDarkPurple
        spanishButton.tintColor = .white
        spanishButton.setImage(tapColoredIcon, for: .normal)
        spanishButton.layer.cornerRadius = 5
        spanishButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.setViewShadow(color: UIColor.black, opacity: 0.3, offset: CGSize(width: 0, height: 1), radius: 1, viewCornerRadius: 0)
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


