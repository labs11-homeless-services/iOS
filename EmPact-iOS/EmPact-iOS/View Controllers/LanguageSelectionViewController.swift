//
//  LanguageSelectionViewController.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController {

    @IBOutlet weak var navBarExtensionView: UIView!
    @IBOutlet weak var searchTagLineLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var spanishButton: UIButton!
    
    let googleMapsController = GoogleMapsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTheme()
        setupViews()
        
        let logoImage = UIImage(named: "logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 700, height: 100))
        imageView.image = logoImage
        //let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
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
    
    func setupViews() {
        
        navBarExtensionView.backgroundColor = .customDarkPurple
        navBarExtensionView.layer.cornerRadius = 16
        navBarExtensionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        // .layerMaxXMinYCorner = top right
    }
    
    func setupTheme() {
        
        self.navigationController?.navigationBar.barTintColor = .customDarkPurple
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.barStyle = .black
        
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
        
        spanishButton.setTitle("Español  ", for: .normal)
        spanishButton.backgroundColor = .customDarkPurple
        spanishButton.tintColor = .white
        spanishButton.setImage(tapColoredIcon, for: .normal)
        spanishButton.layer.cornerRadius = 5
        spanishButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        spanishButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
}
