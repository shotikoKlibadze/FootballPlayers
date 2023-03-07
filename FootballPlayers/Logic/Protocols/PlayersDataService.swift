//
//  PlayersDataService.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

protocol PlayersDataService {
	// Typealias should only be used when really necessary or when providing a real
	// advantage otherwise they are obfuscating only the type which makes it hard to read it
    typealias Result = Swift.Result<[FootballPlayer],Error>
    typealias PlayerResult = Swift.Result<FootballPlayer,Error>

	// async / await should be used instead of completion handlers
    func fetchPlayers(completion: @escaping (Result) -> Void)
    func fetchPlayerInformation(playerID: Int, completion: @escaping (PlayerResult) -> Void)
}
