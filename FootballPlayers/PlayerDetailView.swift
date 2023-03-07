//
//  PlayerDetailView.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 07.03.23.
//

import SwiftUI

struct PlayerDetailView: View {
	// Should be private and a @StateObject
    @ObservedObject var viewModel: PlayerDetailViewModel
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Color.clear.onAppear(perform: viewModel.load)
        case .loading:
            ProgressView()
        case .failed(_):
            Color.clear.onAppear(perform: viewModel.load)
        case .loaded(let information):
            Text(information)
        }
    }
}
struct PlayerDetailView_Previews: PreviewProvider {
    static var previews: some View {
		// The preview is only showing a blank screen
        PlayerDetailView(viewModel: PlayerDetailViewModel(service: RemoteDataRepository(client: MockNetworkClient()), playerID: 3))
    }
}
