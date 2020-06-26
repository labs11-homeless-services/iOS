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
    var details: String?
    var additionalInformation: String?
    var hours: String?
    
    var keywords: String
    var latitude: String?
    var longitude: String?
    
    var name: String
    var phone: String?
    var postalCode: String?
    var state: String
    
    var services: String?
    
    init(address: String?, city: String, details: String, additionalInformation: String?, hours: String?, keywords: String, latitude: String?, longitude: String?, name: String, phone: String?, postalCode: String?, state: String, services: String?) {
        
        self.address = address
        self.city = city
        self.details = details
        self.additionalInformation = additionalInformation
        self.hours = hours
        self.keywords = keywords
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.phone = phone
        self.postalCode = postalCode
        self.state = state
        self.services = services
    }
}
