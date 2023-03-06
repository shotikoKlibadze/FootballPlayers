//
//  FootballPlayerResponse.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

struct FootballPlayerFeedResponse: Codable {
    let items: [FootballPlayerResponse]
}

struct OnePlayerResponse: Codable {
    let player: FootballPlayerResponse
}

struct FootballPlayerResponse: Codable{
    let id: Int
    let name: String
    let information: String
    let priority: String
}
