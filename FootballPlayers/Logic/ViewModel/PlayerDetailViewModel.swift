//
//  PlayerDetailViewModel.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 07.03.23.
//

import Foundation

class PlayerDetailViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded(String)
    }
    
    @Published private(set) var state = State.idle
    
    private let service: PlayersDataService
    private let playerID: Int
    
    init(service: PlayersDataService, playerID: Int) {
        self.service = service
        self.playerID = playerID
    }
    
    func load() {
        state = .loading
        service.fetchPlayerInformation(playerID: playerID) { [weak self] result in
            switch result {
            case .success(let player):
                self?.state = .loaded(player.information)
                print(player.priority?.rawValue ?? "")
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
