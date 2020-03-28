//
//  IndividualResource.swift
//  EmPact-iOS
//
//  Created by Jonah Bergevin on 4/8/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

class IndividualResource: Decodable {
    
    enum IndividualResourceCodingKeys: String, CodingKey {
        case address
        case city
        case details
        case additionalInformation
        case hours
        case keywords
        case latitude
        case longitude
        case name
        case phone
        case postalCode = "postal code"
        case state
        case services
        
        enum AllDetails: String, CodingKey {
            case hours
            case additionalInformation = "additional_information"

            enum AllHours: String, CodingKey {
                case friday
                case monday
                case saturday
                case sunday
                case thursday
                case tuesday
                case wednesday
            }
        }
    }
    
    var address: String?
    var city: String
    var details: Any?
    var additionalInformation: String?
    var hours: String?
    
    var keywords: String
    var latitude: String?
    var longitude: String?
    
    var name: String
    var phone: Any?
    var postalCode: String?
    var state: String
    
    var services: Any?
    

    
    required init(from decoder: Decoder) throws {
        
        // Container representing top level of information, which is a dictionary
        let container = try decoder.container(keyedBy: IndividualResourceCodingKeys.self)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        
        do {
            // Try to decode the value as an array
            details = try container.decodeIfPresent([String].self, forKey: .details)
        } catch {
            
            do {
                // If that doesn't work, try to decode as a single value
                details = try container.decodeIfPresent(String.self, forKey: .details)
            } catch {
                
                do {
                    // Try to decode as a dictionary holding a string
                    let allDetailsContainer = try container.nestedContainer(keyedBy: IndividualResourceCodingKeys.AllDetails.self, forKey: .details)
                    details = try allDetailsContainer.decodeIfPresent(String.self, forKey: .hours)
                    
                } catch {
                    // Finally try to decode as a dictionary of dictionaries
                    let allDetailsContainer = try container.nestedContainer(keyedBy: IndividualResourceCodingKeys.AllDetails.self, forKey: .details)
                    additionalInformation = try allDetailsContainer.decodeIfPresent(String.self, forKey: .additionalInformation)
                    
                    let detailsDescriptionContainer = try allDetailsContainer.nestedContainer(keyedBy: IndividualResourceCodingKeys.AllDetails.AllHours.self, forKey: .hours)
                    details = try detailsDescriptionContainer.decodeIfPresent(String.self, forKey: .monday)
                }
            }
        }
        hours = try container.decodeIfPresent(String.self, forKey: .hours)
        keywords = try container.decode(String.self, forKey: .keywords)
        latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        name = try container.decode(String.self, forKey: .name)
        
        do {
            phone = try container.decodeIfPresent(String.self, forKey: .phone)
        } catch {
            phone = try container.decodeIfPresent(Int.self, forKey: .phone)
        }
    
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        state = try container.decode(String.self, forKey: .state)
        
        do {
            services = try container.decodeIfPresent(String.self, forKey: .services)
        } catch {
            services = try container.decodeIfPresent([String].self, forKey: .services)
        }
    }
}

struct IndividualResourceTopLevel: Decodable {
    
    var JSON: [IndividualResource]
}


