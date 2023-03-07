//
//  FootballPlayer.swift
//  FootballPlayers
//
//  Created by Shotiko Klibadze on 06.03.23.
//

import Foundation
import SwiftUI

enum Priority: String {
    
    case high = "High Priority"
    case mid = "Mid Priority"
    case low = "Low Priority"
    
    var image: UIImage {
        switch self {
        case .high:
            return UIImage(systemName: "arrow.up")!
        case .mid:
            return UIImage(systemName: "arrow.up.arrow.down")!
        case .low:
            return UIImage(systemName: "arrow.down")!
        }
    }
}

struct FootballPlayer: Equatable, Identifiable {

    let id: Int
    let name: String
    let information: String
    let priority: Priority?
    
    init(from response: FootballPlayerResponse) {
        self.id = response.id
        self.name = response.name
        self.information = response.information
        self.priority = .init(rawValue: response.priority)
    }
    
    init(id: Int, name: String, information: String, priority: String) {
        self.id = id
        self.name = name
        self.information = information
        self.priority = .init(rawValue: priority)
    }
}
