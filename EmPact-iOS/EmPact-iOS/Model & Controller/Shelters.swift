//
//  Shelters.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/1/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct Shelters: Decodable {
    
    var address: String
    var city: String
    var name: String
    var state: String
    
    var latitude: String?
    var longitude: String?
    var phone: String?
    var postalCode: String? 

}
