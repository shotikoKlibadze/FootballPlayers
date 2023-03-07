//
//  ViewModelFactory.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 07.03.23.
//

import Foundation

final class ViewModelFactory: ObservableObject {
    
    static func makeAllPplayersViewModel () -> PlayersListViewModel {
        let dataRepository = RemoteDataRepository(client: MockNetworkClient())
        let viewModel = PlayersListViewModel(service: dataRepository)
        return viewModel
    }
    
    static func makePlayerDetailViewModel(plyaerID: Int) -> PlayerDetailViewModel {
        let dataRepository = RemoteDataRepository(client: MockNetworkClient())
        let viewModel = PlayerDetailViewModel(service: dataRepository, playerID: plyaerID)
        return viewModel
    }
}
