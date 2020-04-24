//
//  CategoriesCollectionViewCell.swift
//  EmPact-iOS
//
//  Created by Jonah Bergevin on 3/29/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit
import SceneKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    static let reuseIdentifier = "categoryCell"
    
    // MARK: - Shadow Method
    var shadowLayer: CAShapeLayer!
    var cell: CategoriesCollectionViewCell!
    var cornerRadius: CGFloat = 25.0
    var fillColor: UIColor = .clear // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    
    func layoutSubviews(_ cell: UICollectionViewCell) {
        super.layoutSubviews()
                
        if shadowLayer == nil {
            self.shadowLayer = CAShapeLayer()
            
            self.shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            self.shadowLayer.fillColor = fillColor.cgColor
            
            self.shadowLayer.shadowColor = UIColor.gray.cgColor
            self.shadowLayer.shadowPath = shadowLayer.path
            self.shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            self.shadowLayer.shadowOpacity = 0.8
            self.shadowLayer.shadowRadius = 10 //4
            //self.shadowLayer.cornerRadius = 10
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}


