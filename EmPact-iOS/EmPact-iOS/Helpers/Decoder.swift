//
//  Decoder.swift
//  EmPact-iOS
//
//  Created by Jonah  on 4/27/20.
//  Copyright © 2020 EmPact. All rights reserved.
//

import Foundation

extension Decodable {
    init(jsonData: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: jsonData)
    }
    
    func decodeType<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}


