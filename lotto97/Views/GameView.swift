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
    @State var infoPresented: Bool = false
    @State var outcomePresented: Bool = false
    @State var selectionState: SelectionState = .choosing
    @StateObject var device = DeviceService.shared

    var body: some View {
        Color.myRed
            .edgesIgnoringSafeArea(.top)
            .overlay (
        VStack {
            VStack (alignment: .leading) {
                HStack {
                    Text("Lotto 97")
                        .font(MyFont.body)
                        .fontWeight(.bold)
                    Button {
                        infoPresented = true
                    } label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width:12, height: 12)
                    }
                    .sheet(isPresented: $infoPresented) {
                        InfoView(isPresented: $infoPresented)
                    }
                    Spacer()
                    Text(String(device.numberOfTries()) + (device.numberOfTries() == 1 ? " try" : " tries" ))
                        .font(MyFont.body)
                        .padding(.horizontal, 5)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding([.trailing,.leading], 25)
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Date")
                            .fontWeight(.bold)
                        Text("Savings")
                            .fontWeight(.bold)
                        Text("Family")
                            .fontWeight(.bold)
                    }
                    .frame(width: 150)
                    VStack(alignment: .leading, spacing: 20) {
                        Text(game.state.prettyDate)
                        Text(game.state.prettySavings)
                        Text(game.state.family)
                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxHeight: .infinity)
                .font(MyFont.bigbody)
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
            .background(Color.myRed)
            .foregroundColor(.white)
            VStack(alignment: .center, spacing: 20) {
                VStack(spacing: 0) {
                    switch selectionState {
                    case .choosing:
                        Text(game.state.round.highlightedCharacter)
                            .font(.system(size: 60))
                            .minimumScaleFactor(0.2)
                        Text(game.state.round.message)
                            .font(MyFont.body)
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.5)
                            .padding()
                    case .continuing:
                        Text(game.state.outcome)
                            .font(MyFont.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .minimumScaleFactor(0.5)
                    }
                }
                .frame(maxHeight: .infinity)
                switch selectionState {
                case .choosing:
                    Button {
                        optionOnePressed()
                    } label: {
                        Text(game.state.round.optionOne)
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity)
                            .padding(.all, 15)
                            .font(.system(size: 18))
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
                            .font(.system(size: 18))
                            .minimumScaleFactor(0.5)
                    }
                    .background(Color.myRed)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                case .continuing:
                    Button {
                        continueButtonPressed()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity)
                            .padding(.all, 15)
                            .font(.system(size: 18))
                            .minimumScaleFactor(0.5)
                    }
                    .background(Color.myRed)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(Color.white)
        }.onAppear {
            DeviceService.shared.didTry()
        }
            .fullScreenCover(isPresented: $outcomePresented, content: {
                OutcomeView(isPresented: $outcomePresented, won: game.state.didWin)
            })
        .navigationBarBackButtonHidden(true)
        )
    }
    
    func optionOnePressed() {
        withAnimation {
            selectionState = .continuing
            game.handleSelection(option: 1)
        }
    }
    
    func optionTwoPressed() {
        withAnimation {
            selectionState = .continuing
            game.handleSelection(option: 2)
        }
    }
    
    func continueButtonPressed() {
        if game.state.didEnd {
            outcomePresented = true
        }
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
