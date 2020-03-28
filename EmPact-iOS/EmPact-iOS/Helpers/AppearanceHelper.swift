//
//  AppearanceHelper.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

enum Appearance {
    
    // Custom Font Initialization
    static let heavyItalicFont = UIFont(name: "SFProDisplay-HeavyItalic", size: UIFont.labelFontSize)
    static let thinItalicFont = UIFont(name: "SFProDisplay-ThinItalic", size: UIFont.labelFontSize)
    static let ultraLightFont = UIFont(name: "SFProDisplay-Ultralight", size: UIFont.labelFontSize)
    static let heavyFont = UIFont(name: "SFProDisplay-Heavy", size: UIFont.labelFontSize)
    static let boldItalicFont = UIFont(name: "SFProDisplay-BoldItalic", size: UIFont.labelFontSize)
    static let semiboldItalicFont = UIFont(name: "SFProDisplay-SemiboldItalic", size: UIFont.systemFontSize)
    static let regularFont = UIFont(name: "SFProDisplay-Regular", size: UIFont.labelFontSize)
    static let boldFont = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
    static let mediumItalicFont = UIFont(name: "SFProDisplay-MediumItalic", size: UIFont.labelFontSize)
    static let thinFont = UIFont(name: "SFProDisplay-Thin", size: UIFont.smallSystemFontSize)
    static let semiboldFont = UIFont(name: "SFProDisplay-Semibold", size: UIFont.labelFontSize)
    static let blackItalicFont = UIFont(name: "SFProDisplay-BlackItalic", size: UIFont.labelFontSize)
    static let lightFont = UIFont(name: "SFProDisplay-Light", size: UIFont.labelFontSize)
    static let ultraLightItalicFont = UIFont(name: "SFProDisplay-UltralightItalic", size: UIFont.labelFontSize)
    static let italicFont = UIFont(name: "SFProDisplay-Italic", size: UIFont.labelFontSize)
    
    static let serviceAndDetailFont = UIFont(name: "SFProDisplay-Light", size: 14)
    static let lightItalicFont = UIFont(name: "SFProDisplay-LightItalic", size: UIFont.labelFontSize)
    static let blackFont = UIFont(name: "SFProDisplay-Black", size: UIFont.labelFontSize)
    
    static let mediumFont = UIFont(name: "SFProDisplay-Medium", size: UIFont.smallSystemFontSize)
    static let smallRegularFont = UIFont(name: "SFProDisplay-Regular", size: UIFont.smallSystemFontSize)
    
    // Scalable font
    static func scaledNameLabelFont(with textStyle: UIFont.TextStyle, size: CGFloat) -> UIFont {
        guard let font = boldFont else { fatalError() }
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    // MARK: - Theming
    static func setupTheme() {
        
        // Search Bars
        // Search bar color & theme
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        UISearchBar.appearance().searchBarStyle = UISearchBar.Style.minimal
        UISearchBar.appearance().barTintColor = UIColor.white
        
        // Text of search bar
        UISearchBar.appearance().placeholder = "Search"
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = regularFont
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.customLightestGray
        
        // Labels
        UILabel.appearance().textColor = UIColor.customDarkGray
        
        // Navigation Bar
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customDarkBlack, NSAttributedString.Key.font: Appearance.semiboldFont!]
        UIBarButtonItem.appearance().tintColor = UIColor(red:0.31, green:0.36, blue:0.46, alpha:1.0)
        // Purple: UIColor(red: 0.28, green: 0.19, blue: 0.60, alpha: 1.0)
    }
    
    
}
