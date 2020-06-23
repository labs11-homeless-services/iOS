//
//  SimpleResource.swift
//  EmPact-iOS
//
//  Created by Jonah  on 6/22/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import Foundation

class SimpleResource: Codable {
    var address: String?
    var city: String
    var name: String
    var postalCode: String?
    var state: String
    
    init(address: String?, city: String, name: String, postalCode: String?, state: String) {
        
        self.address = address
        self.city = city
        self.name = name
        self.postalCode = postalCode
        self.state = state
    }
}
