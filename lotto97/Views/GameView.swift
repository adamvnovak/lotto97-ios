//
//  GameView.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/02.
//

import SwiftUI

enum SelectionState {
    case choosing, continuing
}

struct GameView: View {
    @EnvironmentObject var game: Game
    @State var selectionState: SelectionState = .choosing
    
    var body: some View {
        Color.myRed
            .edgesIgnoringSafeArea(.top)
            .overlay (
        VStack {
            VStack {
                Text("Lotto 97")
                    .font(MyFont.body)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Date")
                        Text("Savings")
                        Text("Family")
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        Text(game.state.prettyDate)
                        Text(game.state.prettySavings)
                        Text(game.state.family)
                    }
                }
                
                .frame(maxHeight: .infinity)
                .font(MyFont.bigbody)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.myRed)
            .foregroundColor(.white)
            VStack(alignment: .center, spacing: 20) {
                VStack(spacing: 0) {
                    Text(game.state.round.highlightedCharacter)
                        .font(.system(size: 60))
                    Text(game.state.round.message)
                        .font(MyFont.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxHeight: .infinity)
                Button {
                    optionOnePressed()
                } label: {
                    Text(game.state.round.optionOne)
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 15)
                        .font(.system(size: 20))
                }
                .background(Color.myRed)
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                Button {
                    optionTwoPressed()
                } label: {
                    Text(game.state.round.optionTwo)
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 15)
                        .font(.system(size: 20))
                }
                .background(Color.myRed)
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(Color.white)
        }
            .fullScreenCover(isPresented: $game.state.didEnd, content: {
                OutcomeView(isPresented: $game.state.didEnd, won: game.state.didWin)
            })
        .navigationBarBackButtonHidden(true)
        )
    }
    
    func optionOnePressed() {
        withAnimation {
            selectionState = .continuing
        }
        game.handleSelection(option: 1)
    }
    
    func optionTwoPressed() {
        withAnimation {
            selectionState = .continuing
        }
        game.handleSelection(option: 2)
    }
    
    func continueButtonPressed() {
        withAnimation {
            selectionState = .choosing
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(Game.shared)
    }
}
