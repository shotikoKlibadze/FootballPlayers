//
//  ContentView.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import SwiftUI

struct PlayersListView: View {
    
    @ObservedObject var viewModel: PlayersViewModel
    
    init(viewModel: PlayersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.players, id: \.id) { player in
                NavigationLink(destination: PlayerDetailView(viewModel: ViewModelFactory.makePlayerDetailViewModel(plyaerID: player.id))) {
                    HStack(spacing: 10) {
                        Text(player.name)
                            .fontWeight(.bold)
                        Image(uiImage: player.priority?.image ?? UIImage())
                    }
                    
                }.navigationTitle("Players")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersListView(viewModel: PlayersViewModel(service: RemoteDataRepository(client: MockNetworkClient())))
    }
}
