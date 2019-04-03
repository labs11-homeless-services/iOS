//
//  IndividualResource.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 4/3/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

struct IndividualResource: Decodable {
    var address: String
    var city: String
    var keywords: String
    var name: String
    var state: String
    
    var latitude: String?
    var longitude: String?
    var phone: Int?
    var postalCode: String?
}
