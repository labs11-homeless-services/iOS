//
//  ArrayExceptionHelper.swift
//  EmPact-iOS
//
//  Created by Jonah  on 5/9/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import UIKit

extension Array {
    func canSupport(index: Int ) -> Bool {
        return index >= startIndex && index < endIndex
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIViewController {
    private func presentAlert() {
         let alert = UIAlertController(title: "There was a problem locating that resource.",
                                       message: "Please proceed to the previous screen and try again.",
                                       preferredStyle: .alert)
                            
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
     }
}
