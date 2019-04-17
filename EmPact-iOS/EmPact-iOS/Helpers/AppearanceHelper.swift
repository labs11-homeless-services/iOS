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
    
    // ["SFProDisplay-HeavyItalic", "SFProDisplay-ThinItalic", "SFProDisplay-Ultralight", "SFProDisplay-Heavy", "SFProDisplay-BoldItalic", "SFProDisplay-SemiboldItalic", "SFProDisplay-Regular", "SFProDisplay-Bold", "SFProDisplay-MediumItalic", "SFProDisplay-Thin", "SFProDisplay-Semibold", "SFProDisplay-BlackItalic", "SFProDisplay-Light", "SFProDisplay-UltralightItalic", "SFProDisplay-Italic", "SFProDisplay-LightItalic", "SFProDisplay-Black", "SFProDisplay-Medium"]
    
    static let heavyItalicFont = UIFont(name: "SFProDisplay-HeavyItalic", size: UIFont.labelFontSize)
    static let thinItalicFont = UIFont(name: "SFProDisplay-ThinItalic", size: UIFont.labelFontSize)
    static let ultraLightFont = UIFont(name: "SFProDisplay-Ultralight", size: UIFont.labelFontSize)
    static let heavyFont = UIFont(name: "SFProDisplay-Heavy", size: UIFont.labelFontSize)
    static let boldItalicFont = UIFont(name: "SFProDisplay-BoldItalic", size: UIFont.labelFontSize)
    static let semiboldItalicFont = UIFont(name: "SFProDisplay-SemiboldItalic", size: UIFont.labelFontSize)
    static let regularFont = UIFont(name: "SFProDisplay-Regular", size: UIFont.smallSystemFontSize)
    static let boldFont = UIFont(name: "SFProDisplay-Bold", size: UIFont.labelFontSize)
    static let mediumItalicFont = UIFont(name: "SFProDisplay-MediumItalic", size: UIFont.labelFontSize)
    static let thinFont = UIFont(name: "SFProDisplay-Thin", size: UIFont.smallSystemFontSize)
    static let semiboldFont = UIFont(name: "SFProDisplay-Semibold", size: UIFont.labelFontSize)
    static let blackItalicFont = UIFont(name: "SFProDisplay-BlackItalic", size: UIFont.labelFontSize)
    static let lightFont = UIFont(name: "SFProDisplay-Light", size: UIFont.smallSystemFontSize)
    static let ultraLightItalicFont = UIFont(name: "SFProDisplay-UltralightItalic", size: UIFont.labelFontSize)
    static let italicFont = UIFont(name: "SFProDisplay-Italic", size: UIFont.labelFontSize)
    static let lightItalicFont = UIFont(name: "SFProDisplay-LightItalic", size: UIFont.labelFontSize)
    static let blackFont = UIFont(name: "SFProDisplay-Black", size: UIFont.labelFontSize)
    static let mediumFont = UIFont(name: "SFProDisplay-Medium", size: UIFont.labelFontSize)
    
    // Scalable font
    static func scaledNameLabelFont(with textStyle: UIFont.TextStyle, size: CGFloat) -> UIFont {
        guard let font = boldFont else { fatalError() }
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }
    
    // MARK: - Theming
    
    static func setupTheme() {
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        
        UISearchBar.appearance().searchBarStyle = UISearchBar.Style.minimal
        UISearchBar.appearance().barTintColor = UIColor.white
        UISearchBar.appearance().placeholder = "Search"
        
        
        
        
    }
    
    
}
