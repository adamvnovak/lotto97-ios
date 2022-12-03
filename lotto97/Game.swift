//
//  Game.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/02.
//

import Foundation

@MainActor class Game: NSObject, ObservableObject {
    @Published var state: GameState
    
    static let shared = Game()
    
    private override init() {
        state = GameState()
        super.init()
    }
    
    func reset() {
        state = GameState()
    }
    
}

struct GameState {
    var round: Int = 1
    var date: String = "September 1997"
    var savings: Int = 10000
    var prettySavings: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "$" + (numberFormatter.string(from: NSNumber(value:savings)) ?? String(savings))
    }
    var family: String = "👨 👩 👦 👧"
    
    var message: String = "You’re put in a scenario where you must attack. Do you?"
    var highlightedCharacter: String = "👨"
    var option1: String = "Run away"
    var option2: String = "Fight back"
}
