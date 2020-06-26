//
//  Protocols.swift
//  EmPact-iOS
//
//  Created by Jonah  on 6/22/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import Foundation

// MARK: - Hamburger Menu protocol
protocol MenuActionDelegate {
    func openSegue(_ segueName: String, sender: AnyObject?)
    func reopenMenu()
}
