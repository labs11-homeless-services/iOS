//
//  DropShadow.swift
//  EmPact-iOS
//
//  Created by Jonah Bergevin on 4/15/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import UIKit

extension UIView {
    func setViewShadow(color: UIColor?, opacity: Float?, offset: CGSize?, radius: CGFloat, viewCornerRadius: CGFloat?) {
        layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = opacity ?? 1.0
        layer.shadowOffset = offset ?? CGSize.zero
        layer.shadowRadius = radius
    }
}

extension UICollectionViewCell {
    func setCellShadow(cell: UICollectionViewCell, color: UIColor?, opacity: Float?, offset: CGSize?, radius: CGFloat, viewCornerRadius: CGFloat?) {
        cell.layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        cell.layer.shadowOpacity = opacity ?? 1.0
        cell.layer.shadowOffset = offset ?? CGSize.zero
        cell.layer.shadowRadius = radius
    }
}

extension UIStackView { // This only sets the shadow on the text
    func setStackShadow(color: UIColor?, opacity: Float?, offset: CGSize?, radius: CGFloat, viewCornerRadius: CGFloat?) {
        layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = opacity ?? 1.0
        layer.shadowOffset = offset ?? CGSize.zero
        layer.shadowRadius = radius
    }
}

extension UILabel { // This only sets the shadow on the text
    func setLabelShadow(color: UIColor?, opacity: Float?, offset: CGSize?, radius: CGFloat, viewCornerRadius: CGFloat?) {
        layer.shadowColor = color?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = opacity ?? 1.0
        layer.shadowOffset = offset ?? CGSize.zero
        layer.shadowRadius = radius
    }
}
