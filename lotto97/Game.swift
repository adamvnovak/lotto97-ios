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
            if
                (state.roundIndex == 3 && !state.doesHaveMaid) ||
                    (state.roundIndex == 6 && !state.didStartCompany) ||
                    (state.roundIndex == 12 && !state.isPregnant) ||
                    (state.roundIndex == 4 || state.roundIndex == 7 || state.roundIndex == 13) {
                state.roundIndex += 2
            } else {
                state.roundIndex += 1
            }
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
    
    var dateComponents = DateComponents(year: 1997, month: 8)
    var prettyDate: String {
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        let date =  userCalendar.date(from: dateComponents)!
        let formatter = DateFormatter()
        formatter.dateFormat = "M/yyyy"
        return formatter.string(from: date)
    }
    
    var savings: Int = 10000
    var prettySavings: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return "$" + (numberFormatter.string(from: NSNumber(value:savings)) ?? String(savings))
    }
    var family: String = "👨 👩 👦"
    
    //Flags
    var isPregnant = false
    var doesHaveMaid = false
    var didStartCompany = false
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
        1: Round(message: "You receive unfortunate news: you’ve been laid off.",
                 highlightedCharacter: "👨",
                 optionOne: "Start a boba shop with your friends.",
                 optionTwo: "Look for a job at another company.",
                 outcomeOne: "You invest $1000 into milk tea and tapioca (and your wife thinks you’re crazy).",
                 outcomeTwo: "You begin searching for a new job in the area.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 1000
                     newState.didStartCompany = true
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        2: Round(message: "You get a call from school that your son’s behavior has gotten extremely disruptive.",
                 highlightedCharacter: "👩",
                 optionOne: "Hire a foreign maid to take care of him.",
                 optionTwo: "Punish him at home, but this time more severely.",
                 outcomeOne: "You budget out $5000 for a Filipino maid for the next year or so.",
                 outcomeTwo: "Your son seems to shape up and listen to you.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 5000
                     newState.doesHaveMaid = true
                     newState.family += " 👩‍💼"
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        3: Round(message: "You think that having another child will improve your son's behavior.",
                 highlightedCharacter: "👨",
                 optionOne: "Try for a baby.",
                 optionTwo: "Don’t try for a baby.",
                 outcomeOne: "Congratulations! Your wife is now pregnant.",
                 outcomeTwo: "Maybe just wait until things get better financially?",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.isPregnant = true
                     newState.family = newState.family.replacingOccurrences(of: "👩 ", with: "🤰 ")
                     newState.isPregnant = true
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        4: Round(message: "Your son steals from the store, but the maid catches him just in time. The officers ask for cash under the table to not take the deal to court.",
                 highlightedCharacter: "👩",
                 optionOne: "Pay up.",
                 optionTwo: "Don't pay up.",
                 outcomeOne: "You pay up $1000 and the officers keep everything under the table.",
                 outcomeTwo: "The deal is investigated further, and it’s discovered that the maid is staying with the family illegally. She is deported immediately.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 1000
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👩‍💼", with: "")
                     newState.didEnd = true
                     return newState
                 }),
        5: Round(message: "The misbehavior does not end. Your son steals from the local store, is caught, and is sent to children’s jail.",
                 highlightedCharacter: "👩",
                 optionOne: "Give up. There’s no hope for this child.",
                 optionTwo: "Bail him out of jail.",
                 outcomeOne: "Your child remains in jail for months on end.",
                 outcomeTwo: "You spend every last dime on bailing him out of jail and have nothing left to cover the bills.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👦 ", with: "")
                     newState.didEnd = true
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 10000
                     return newState
                 }),
        6: Round(message: "Your accountant goes to lunch but leaves his computer on. You have the opportunity to sneak some extra cash into your account.",
                 highlightedCharacter: "👩",
                 optionOne: "Transfer $100 into your account.",
                 optionTwo: "Transfer $1000 into your account.",
                 outcomeOne: "You snuck $100 into your account, and your accountant doesn’t seem to notice.",
                 outcomeTwo: "You snuck $1000 into your account, and your accountant doesn’t seem to notice.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings += 100
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings += 1000
                     return newState
                 }),
        7: Round(message: "Your business isn’t doing too hot. You’re super stressed out.",
                 highlightedCharacter: "👨",
                 optionOne: "Pick up smoking again to manage your stress.",
                 optionTwo: "Pretend like everything is okay.",
                 outcomeOne: "The new smoking habit helps… but your wife soon finds out. She’s finally had enough. She divorces you for lying to her.",
                 outcomeTwo: "Things only get more and more stressful as the business continues to fare poorly. You eventually decide the best remedy is to take your life.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👩 ", with: "")
                     newState.family = newState.family.replacingOccurrences(of: "🤰 ", with: "")
                     newState.didEnd = true
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👨 ", with: "")
                     newState.didEnd = true
                     return newState
                 }),
        8: Round(message: "You finally find a job at the start of the year. It’s a downgrade from your previous job, but it’s something.",
                 highlightedCharacter: "👨",
                 optionOne: "Take the job. You need what you can get.",
                 optionTwo: "Leave the job. You can find better offers elsewhere.",
                 outcomeOne: "You take the job. To your surprise, they offer you a $500 signing bonus.",
                 outcomeTwo: "You keep looking for a job.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings += 500
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        9: Round(message: "You attend your mother’s 80th birthday party. As tradition calls for, you should give her a cash gift in a red envelope.",
                 highlightedCharacter: "👨",
                 optionOne: "You’re feeling stingy.",
                 optionTwo: "You’re feeling generous.",
                 outcomeOne: "You give $100 to grandma. She’s disappointed, but understands.",
                 outcomeTwo: "You give $500 to grandma. She returns the favor with lots of hugs and kisses.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 100
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 500
                     return newState
                 }),
        10: Round(message: "You overhear your parents talking about their difficult financial situation. You’ve been studying lottery science and are confident in your ability to help.",
                 highlightedCharacter: "👦",
                 optionOne: "Buy lottery tickets using your parent’s money.",
                 optionTwo: "Don’t buy lottery tickets.",
                 outcomeOne: "You buy $50 worth of lottery tickets.",
                 outcomeTwo: "You hold yourself back. Lottery tickets are not the smartest choice right now.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 50
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        11: Round(message: "Your friend introduces you to a stonks community called “Singapore Bets. You hear advice to buy right now because prices are low.",
                 highlightedCharacter: "👨",
                 optionOne: "Buy low, sell high. To the moon 🚀",
                 optionTwo: "It’s a bear market. Hold steady and play it conservative 🐻",
                 outcomeOne: "You get carried away and drop all your money on stonks. The next week, the market crashes again, and your family can’t pay the bills.",
                 outcomeTwo: "You don’t purchase any stocks, and you’re glad—the market continues to trend downwards.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 8000
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        12: Round(message: "The Filipino neighbor sees you in the hall and asks for your help. She's been busy lately, so she asks you to send off an envelope with cash to her relative.",
                 highlightedCharacter: "👩‍💼",
                 optionOne: "Send the envelope just like she asks.",
                 optionTwo: "Take the cash for your family.",
                 outcomeOne: "You didn’t earn any extra cash, but you feel good inside for being honest.",
                 outcomeTwo: "Extra $100 into your family’s pockets. Bingo!",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     if gameState.isPregnant == true {
                         newState.family += " 👶 "
                         newState.family = newState.family.replacingOccurrences(of: "🤰 ", with: "👩 ")
                     }
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings += 100
                     if gameState.isPregnant == true {
                         newState.family += " 👶 "
                         newState.family = newState.family.replacingOccurrences(of: "🤰 ", with: "👩 ")
                     }
                     return newState
                 }),
        13: Round(message: "Your baby is born! But bad news: doctor says she has a life-threatening medical condition.",
                 highlightedCharacter: "👩",
                 optionOne: "Pay the hefty but necessary fees.",
                 optionTwo: "Hope that your baby makes it through on their own.",
                 outcomeOne: "You pay the initial fees, but they start to add up quickly. By the time they're out of the hospital, you’ve down $5000.",
                 outcomeTwo: "Your baby passes away.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 5000
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👶 ", with: "")
                     newState.didEnd = true
                     return newState
                 }),
        14: Round(message: "Even though financial times are tough, you’ve agreed that it might not be so bad to try for a child.",
                 highlightedCharacter: "👩",
                 optionOne: "Try for a child",
                 optionTwo: "Don’t try for a child",
                 outcomeOne: "Congrajulations! You're pregnant.",
                 outcomeTwo: "Your husband grows slightly more annoyed with you.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👩 ", with: "🤰 ")
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        15: Round(message: "One of the students at school makes fun of you for having a maid. He starts to push you around in the bathroom and even throws hands.",
                 highlightedCharacter: "👦",
                 optionOne: "Fight back.",
                 optionTwo: "Take the punches.",
                 outcomeOne: "You severely injure the bully while fighting back. The principal has no choice but to expel you from the school.",
                 outcomeTwo: "You get severely injured. Your family must pay up $1000 in health costs.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.family = newState.family.replacingOccurrences(of: "👦 ", with: "")
                     newState.didEnd = true
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 1000
                     return newState
                 }),
        16: Round(message: "You get the opportunity to watch your favorite inspirational speaker in person. He’s scheduled to give a talk on hope during the crisis.",
                 highlightedCharacter: "👩",
                 optionOne: "Attend.",
                 optionTwo: "Don't attend.",
                 outcomeOne: "You cough up $1000 to attend the event. It's a great time, but it feels a bit like a waste.",
                 outcomeTwo: "You don't attend. Your husband seems to be a little happier around the house now.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings -= 1000
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        17: Round(message: "You’re considering selling the one old family car to provide a greater financial cushion for the family.",
                 highlightedCharacter: "👨",
                 optionOne: "Take the car to the junkyard.",
                 optionTwo: "Keep the car.",
                 outcomeOne: "It turns out your car isn’t worth much of anything. You make $100, but now have an hour less each day because of the need to walk.",
                 outcomeTwo: "You don’t make any extra cash… but it’s not like you would have anyways.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings += 100
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     return newState
                 }),
        18: Round(message: "You receive a box of baby chicks for your birthday!",
                 highlightedCharacter: "👦",
                 optionOne: "Sell the chicks for some easy cash.",
                 optionTwo: "Raise them into chickens.",
                 outcomeOne: "You make a quick $10 for selling the baby chicks.",
                 outcomeTwo: "You raise them into chickens, then sell them when they’re worth even more. You earn $100 for them in total.",
                 outcomeOneClosure: { gameState in
                     var newState = gameState
                     newState.savings += 10
                     return newState
                 },
                 outcomeTwoClosure: { gameState in
                     var newState = gameState
                     newState.savings += 100
                     return newState
                 }),
    ]
}
