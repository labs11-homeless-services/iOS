//
//  Categories.swift
//  EmPact-iOS
//
//  Created by Audrey Welch on 3/28/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class Categories: Codable, FirebaseItem {
    var recordIdentifier: String
    var categoryName: String
}

struct Education {
    var address: String
    var city: String
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var state: String
    var categories: Categories
}

struct EmergencyServices {
    var address: String
    var city: String
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var state: String
    var categories: Categories
}

struct food {
    var address: String
    var city: String
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var state: String
    var categories: Categories
}

struct healthcare {
    var address: String
    var city: String
    var details: String?
    var keywords: String?
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var services: String?
    var state: String
    var categories: Categories
}

struct hygiene {
    var address: String
    var city: String
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var state: String
    var categories: Categories
}

struct OutreachServices {
    var address: String
    var city: String
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var state: String
    var categories: Categories
}

struct Shelters {
    var address: String
    var city: String
    var latitude: String?
    var longitude: String?
    var name: String
    var phone: String
    var postalCode: String? // Needs coding keys
    var state: String
    var categories: Categories
}

struct SingleResource {
    let singleResourceId: String
    
}
