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
    
    //Handle option 1 or 2
    func handleSelection(option: Int) {
        state = option == 1 ? state.round.outcomeOneClosure(state) : state.round.outcomeTwoClosure(state)
        state.outcome = option == 1 ? state.round.outcomeOne : state.round.outcomeTwo
        
        if state.savings <= 0 || state.roundIndex == Round.ALLROUNDS.count {
            state.didEnd = true
        } else {
            state.roundIndex += 1
        }
        if state.dateComponents.month == 12 {
            state.dateComponents.month = 1
            state.dateComponents.year! += 1
        } else {
            state.dateComponents.month! += 1
        }
    }
    
}

struct GameState {
    var didEnd: Bool = false
    var didWin: Bool {
        return roundIndex == Round.ALLROUNDS.count
    }
    
    var outcome: String = ""
    var roundIndex: Int = 1
    var round: Round {
        return Round.ALLROUNDS[roundIndex]!
    }
    
    var dateComponents = DateComponents(year: 1997, month: 7)
    var prettyDate: String {
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        let date =  userCalendar.date(from: dateComponents)!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    var savings: Int = 10000
    var prettySavings: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "$" + (numberFormatter.string(from: NSNumber(value:savings)) ?? String(savings))
    }
    var family: String = "👨 👩 👦 👧"
}

struct Round {
    let message: String
    let highlightedCharacter: String
    let optionOne: String
    let optionTwo: String
    let outcomeOne: String
    let outcomeTwo: String
    let outcomeOneClosure: (GameState) -> GameState
    let outcomeTwoClosure: (GameState) -> GameState

    //MEDIAN INCOME IN SINGAPORE in 1997: $3617, or 3500
    static let ALLROUNDS: [Int:Round] = [
        1: Round(message: "hi",
                 highlightedCharacter: "OMlaksdjfkajsdf",
                 optionOne: "masdf",
                 optionTwo: "hi",
                 outcomeOne: "",
                 outcomeTwo: "",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 100
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 100
                     return newState
                 }),
        2: Round(message: "OMlaksdjfkajsdf",
                 highlightedCharacter: "👧",
                 optionOne: "OMlaksdjfkajsdf",
                 optionTwo: "OMlaksdjfkajsdf",
                 outcomeOne: "OMlaksdjfkajsdf",
                 outcomeTwo: "OMlaksdjfkajsdf",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 100
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 100
                     return newState
                 })
    ]
}
