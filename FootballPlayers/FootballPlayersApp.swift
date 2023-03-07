//
//  FootballPlayersApp.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import SwiftUI

@main
struct FootballPlayersApp: App {
    
    var body: some Scene {
        WindowGroup {
            PlayersListView(viewModel: ViewModelFactory.makeAllPplayersViewModel())
        }
    }
}
