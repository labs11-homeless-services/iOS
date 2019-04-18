//
//  IconImageHelper.swift
//  EmPact-iOS
//
//  Created by Madison Waters on 4/2/19.
//  Copyright © 2019 EmPact. All rights reserved.
//

import Foundation

enum CategoryIconImages: String {
    case shelter = "C-shelter"
    case education = "C-education"
    case food = "C-food"
    case healthcare = "C-health-care"
    case hygiene = "C-hygiene"
    case outreach = "C-outreach-services"
    case legal = "C-legal"
    case jobs = "C-jobs"
}

enum SubcategoryIconImages: String {
    case all
    case women = "S-woman"
    case men = "S-man"
    case youth = "S-youth"
    case ged = "S-GED"
    case publicComputers = "S-computers"
    case foodPantries = "S-food_pantry"
    case foodStamps = "S-food_stamps"
    case clinics = "S-clinic"
    case emergency = "S-emergency"
    case hiv = "S-hiv_aids"
    case mentalHealth = "S-mental_health"
    case rehab = "S-rehab"
    case bathrooms = "S-bathroom"
    case showers = "S-shower"
    case benefits
    case afterSchool = "S-after_school"
    case domesticViolence
    case socialServices = "S-social_service"
}
