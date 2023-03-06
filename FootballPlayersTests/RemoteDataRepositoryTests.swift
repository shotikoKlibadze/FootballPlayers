//
//  FootballPlayersTests.swift
//  FootballPlayersTests
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import XCTest
@testable import FootballPlayers
final class RemoteDataRepositoryTests: XCTestCase {

    //Make request call once
    func test_fetch_requestedDataFromURL() {
        let url = anyURL()
        
        let (sut, client) = makeSUT()
        
        sut.fetchPlayers(completion: { _ in})
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //Make request call twice
    func test_fetch_requestedDataFromURLTwice() {
        let url = anyURL()
        
        let (sut, client) = makeSUT()
        
        sut.fetchPlayers(completion: { _ in})
        sut.fetchPlayers(completion: {_ in })
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    //Delivers connectivity error
    func test_fetch_deliversErorOnClientError() {
        let(sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteDataRepository.Error.connectivity)) {
            let error = anyNSError()
            client.complete(with: error)
        }
    }
    
    //Delivers error on HTTPResponse (invalid data)
    func test_load_deliversErrorOnNo200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 300, 400, 500].enumerated().forEach { index, code  in
            expect(sut, toCompleteWith: .failure(RemoteDataRepository.Error.invalidData)) {
                let json = makeItemsJson(items: [])
                client.complete(withstatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_fetch_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteDataRepository.Error.invalidData)) {
            let invalidJSON = Data.init()
            client.complete(withstatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_fetch_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let player1 = makeItem(id: 1, name: "Ronaldo", information: "Brazilian", priority: "High Priority")
        let player2 = makeItem(id: 2, name: "Messi", information: "Argentinian", priority: "Mid Priority")
        let player3 = makeItem(id: 3, name: "Kvaratsxelia", information: "Georgian", priority: "Low Priority")
        let player4 = makeItem(id: 4, name: "Totti", information: "Italian", priority: "High Priority")
        
        let items = [player1.model,
                     player2.model,
                     player3.model,
                     player4.model]
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJson(items: [player1.json, player2.json, player3.json, player4.json])
            client.complete(withstatusCode: 200, data: json)
        }
    }
    
    func test_fetch_deliversOneItemOn200HTTPResponseWithJSONItem() {
        let (sut, client) = makeSUT()
        let playerID = 3
        let exp = expectation(description: "Wait for load to complete")
        sut.fetchPlayerInformation(playerID: playerID) { result in
            switch result {
            case .success(let player):
                XCTAssertEqual(player.id, playerID)
            case .failure(_):
                XCTFail()
            }
            exp.fulfill()
        }
        client.completePlayerInformationFetch(withstatusCode: 200, playerID: playerID)
        waitForExpectations(timeout: 1)
    }
    
    //MARK: - Helpers
    private class NetworkClientSpy: NetworkClient {
        
        private var messages = [(url: URL, completion:(NetworkClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map({$0.url})
        }
        
        func fetch(from url: URL, completion: @escaping (NetworkClient.Result) -> Void) {
            messages.append((url,completion))
        }
        
        func fetch(from url: URL, id: Int, completion: @escaping (NetworkClient.Result) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withstatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
        
        func completePlayerInformationFetch(withstatusCode code: Int, playerID: Int, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            let player = FootballPlayer(id: playerID, name: "someName", information: "someInfo", priority: "High Priority")
            let playerPriority = player.priority?.rawValue ?? ""
            let itemJSON = [
                "id": player.id,
                "name" : player.name,
                "information": player.information,
                "priority": playerPriority
            ].compactMapValues{$0}
            let JSONdata =  try! JSONSerialization.data(withJSONObject: ["player": itemJSON])
            messages[index].completion(.success((JSONdata, response)))
        }
    }
    
    private func makeSUT() -> (sut:RemoteDataRepository, client: NetworkClientSpy) {
        let client = NetworkClientSpy()
        let sut = RemoteDataRepository(client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteDataRepository, toCompleteWith expectedResult: PlayersDataService.Result, when action: () -> Void,file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load to complete")
        
        sut.fetchPlayers { recievedResult in
            switch ( recievedResult, expectedResult) {
            case let (.success(recievedItems), .success(expectedItems)):
                XCTAssertEqual(recievedItems, expectedItems, file: file, line: line)
            case let (.failure(recievedError as RemoteDataRepository.Error), .failure(expectedError as RemoteDataRepository.Error)):
                XCTAssertEqual(recievedError, expectedError, file: file, line: line)
            default:
                XCTFail()
            }
            exp.fulfill()
        }
        action()
        waitForExpectations(timeout: 1)
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
    
    private func makeItemsJson(items: [[String: Any]]) -> Data {
        let JSONdata =  try! JSONSerialization.data(withJSONObject: ["items": items])
        return JSONdata
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any Error", code: 0)
    }
    
}
