//
//  PlayersDataService.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

protocol PlayersDataService {
    
    typealias Result = Swift.Result<[FootballPlayer],Error>
    typealias PlayerResult = Swift.Result<FootballPlayer,Error>
    
    func fetchPlayers(completion: @escaping (Result) -> Void)
    func fetchPlayerInformation(playerID: Int, completion: @escaping (PlayerResult) -> Void)
}
