//
//  ViewModel.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation


class PlayersViewModel: ObservableObject {
    
    @Published var players: [FootballPlayer] = []
    private let service: PlayersDataService
    
    init(service: PlayersDataService) {
        self.service = service
        getPlayers()
    }
    
    func getPlayers() {
        service.fetchPlayers { [weak self] result in
            switch result {
            case .success(let players):
                self?.players.append(contentsOf: players)
            case .failure(_):
                break
            }
        }
    }
}
