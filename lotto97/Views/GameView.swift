//
//  GameView.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/02.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: Game
    @State var isOutcomePresented: Bool = false
    
    var body: some View {
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
                        Text(game.state.date)
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
                    Text(game.state.highlightedCharacter)
                        .font(.system(size: 60))
                    Text(game.state.message)
                        .font(MyFont.body)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(maxHeight: .infinity)
                Button {
                    optionOnePressed()
                } label: {
                    Text(game.state.option1)
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10)
                }
                .background(Color.myRed)
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                Button {
                    optionTwoPressed()
                } label: {
                    Text(game.state.option2)
                        .frame(maxWidth: .infinity)
                        .frame(maxWidth: .infinity)
                        .padding(.all, 10)
                }
                .background(Color.myRed)
                .foregroundColor(.white)
                .cornerRadius(20)
                .shadow(radius: 5)
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
        .sheet(isPresented: $isOutcomePresented) {
            OutcomeView(isPresented: $isOutcomePresented, won: game.state.round == 15)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func optionOnePressed() {
        
    }
    
    func optionTwoPressed() {
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(Game.shared)
    }
}
