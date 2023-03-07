//
//  ViewModel.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation


class PlayersListViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded([FootballPlayer])
    }
    
    @Published private(set) var state = State.idle
    
    private let service: PlayersDataService
    
    init(service: PlayersDataService) {
        self.service = service
    }
    
    func load() {
        state = .loading
        service.fetchPlayers { [weak self] result in
            switch result {
            case .success(let players):
                self?.state = .loaded(players)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
