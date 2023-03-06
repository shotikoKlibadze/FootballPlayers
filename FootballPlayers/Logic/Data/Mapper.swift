//
//  Mapper.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

final class Mapper<Model: Codable> {
    
    static func map(data: Data, response: HTTPURLResponse) throws -> Model {
        guard response.statusCode == 200, let response = try? JSONDecoder().decode(Model.self, from: data) else {
            throw RemoteDataRepository.Error.invalidData
        }
        return response
    }
}
