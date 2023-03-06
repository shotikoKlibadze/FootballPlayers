//
//  NetworkClient.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

protocol NetworkClient {
    
    typealias Result = Swift.Result<(Data, HTTPURLResponse),Error>
    
    func fetch(from url: URL, completion: @escaping (Result) -> Void)
    func fetch(from url: URL, id: Int, completion: @escaping (Result) -> Void)
    
}
