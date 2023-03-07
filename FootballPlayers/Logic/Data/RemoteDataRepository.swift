//
//  RemoteDataRepository.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

final class RemoteDataRepository: PlayersDataService {
    
    private let client: NetworkClient
    
    static var priority: Priority = .low
    
    typealias AllPlayersResult = PlayersDataService.Result
    typealias PlayerResult = PlayersDataService.PlayerResult
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func fetchPlayers(completion: @escaping (AllPlayersResult) -> Void) {
        let url = URL(string: "http://any-url.com")!
        client.fetch(from: url) { [weak self] result in
            switch result {
            case let .success((data, response)):
                self?.map(data: data, response: response, completion: { (mapperResult: Result<FootballPlayerFeedResponse,Swift.Error>) in
                    switch mapperResult {
                    case .success(let mapperResponse):
                        completion(.success(mapperResponse.items.map({FootballPlayer(from: $0)}).filter({ player in
                            switch RemoteDataRepository.priority {
                            case .high:
                                return player.priority == .high
                            case .mid:
                                return player.priority == .high || player.priority == .mid
                            case .low:
                                return true
                            }
                        })))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    func fetchPlayerInformation(playerID: Int, completion: @escaping (PlayerResult) -> Void) {
        let url = URL(string: "http://any-url.com")!
        client.fetch(from: url, id: playerID) {  [weak self] result in
            switch result {
            case let .success((data, response)):
                self?.map(data: data, response: response, completion: { (mapperResult: Result<OnePlayerResponse,Swift.Error>) in
                    switch mapperResult {
                        
                    case .success(let mapperResponse):
                        completion(.success(FootballPlayer(from: mapperResponse.player)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    func map<T:Codable>(data: Data, response: HTTPURLResponse, completion: @escaping (Swift.Result<T,Swift.Error>) -> Void) {
        do {
            let result = try Mapper<T>.map(data: data, response: response)
            completion(.success(result))
        } catch (let error){
            completion(.failure(error))
        }
    }
}
