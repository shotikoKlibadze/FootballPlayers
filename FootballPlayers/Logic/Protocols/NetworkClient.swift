//
//  NetworkClient.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation

protocol NetworkClient {

	// Do we really need to returns the full response?
	// Structs should be preferred over tuples because then it's clearer what the properties are
    typealias Result = Swift.Result<(Data, HTTPURLResponse),Error>

	// async / await should be used instead of completion handlers
	// "from" parameter should be "url" to make it clear what's expected
    func fetch(from url: URL, completion: @escaping (Result) -> Void)
    func fetch(from url: URL, id: Int, completion: @escaping (Result) -> Void)
    
}
