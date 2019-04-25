//
//  CategoriesCollectionViewCell.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    static let reuseIdentifier = "categoryCell"
    
    // MARK: - Shadow Method
    var shadowLayer: CAShapeLayer!
    var cell: CategoriesCollectionViewCell!
    var cornerRadius: CGFloat = 25.0
    var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    func layoutSubviews(_ cell: UICollectionViewCell) {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            self.shadowLayer = CAShapeLayer()
            
            self.shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            self.shadowLayer.fillColor = fillColor.cgColor
            
            self.shadowLayer.shadowColor = UIColor.black.cgColor
            self.shadowLayer.shadowPath = shadowLayer.path
            self.shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.shadowLayer.shadowOpacity = 0.6
            self.shadowLayer.shadowRadius = 4
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}


