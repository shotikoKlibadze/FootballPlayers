//
//  MockNetworkClient.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

class MockNetworkClient: NetworkClient {
    
    let response = HTTPURLResponse(
        url: URL(string: "http://any-url.com")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil)!
    
    func fetch(from url: URL, completion: @escaping (NetworkClient.Result) -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success((self.getAllData(), self.response)))
        }
    }
    
    func fetch(from url: URL, id: Int, completion: @escaping (NetworkClient.Result) -> Void) {
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success((self.getDataForPlayer(playerID: id), self.response)))
        }
    }
    
    lazy var mockData = [
        makeItem(id: 1, name: "Ronaldo", information: "Brazilian", priority: "High Priority"),
        makeItem(id: 2, name: "Messi", information: "Argentinian", priority: "Mid Priority"),
        makeItem(id: 3, name: "Kvaratsxelia", information: "Georgian", priority: "Low Priority"),
        makeItem(id: 4, name: "Totti", information: "Italian", priority: "High Priority")
    ]
   
}

private extension MockNetworkClient {
    
    func getDataForPlayer(playerID: Int) -> Data {
        let playerArr = mockData.filter({$0.model.id == playerID})
        let player = playerArr.first.map({$0.json})!
        let data = makeJsonOfOnePlayer(item: player)
        return data
    }
    
    func getAllData() -> Data {
        let items = mockData.map({$0.json})
        let data = makeJsonOFallPlayers(items: items)
        return data
    }
    
    func makeItem(id: Int, name: String, information: String, priority: String) -> (model: FootballPlayer, json: [String: Any]) {
        let player = FootballPlayer(id: id, name: name, information: information, priority: priority)
        let playerPriority = player.priority?.rawValue ?? ""
        let itemJSON = [
            "id": player.id,
            "name" : player.name,
            "information": player.information,
            "priority": playerPriority
        ].compactMapValues{$0}
        return(player, itemJSON)
    }
    
    func makeJsonOfOnePlayer(item: [String: Any]) -> Data {
        let JSONdata =  try! JSONSerialization.data(withJSONObject: ["player": item])
        return JSONdata
    }
    
    func makeJsonOFallPlayers(items: [[String: Any]]) -> Data {
        let JSONdata =  try! JSONSerialization.data(withJSONObject: ["items": items])
        return JSONdata
    }
}
