//
//  ContentView.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import SwiftUI

struct PlayersListView: View {
	// Should be private and a @StateObject
    @ObservedObject var viewModel: PlayersListViewModel
    
    init(viewModel: PlayersListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear(perform: viewModel.load)
        case .loading:
            ProgressView()
        case .failed(_):
            Color.clear.onAppear(perform: viewModel.load)
        case .loaded(let players):
            NavigationView {
                List(players, id: \.id) { player in
					// This view shouldn't know anything about the PlayerDetailView
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		// The preview is only showing a blank screen
        PlayersListView(viewModel: PlayersListViewModel(service: RemoteDataRepository(client: MockNetworkClient())))
    }
}
