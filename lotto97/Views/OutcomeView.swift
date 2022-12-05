//
//  LoseView.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/02.
//

import SwiftUI

struct OutcomeView: View {
    @EnvironmentObject var game: Game
    @Binding var isPresented: Bool

    var won: Bool
    var titleText: String {
        won ? "Congrajulations!" : "Tough luck."
    }
    var bodyText: String {
        won ? "Good job" : "You ran out of money and didn't make it through the 1997 Asian financial crisis."
    }
    
    var body: some View {
        Color.myRed
            .edgesIgnoringSafeArea(.top)
            .overlay (
        VStack(alignment: .center, spacing: 20) {
            VStack {
                Text("Lotto 97")
                    .font(MyFont.body)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Spacer()
                Text(titleText)
                    .font(MyFont.title)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.myRed)
            VStack {
                Text(bodyText)
                    .font(MyFont.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                Spacer()
                Button {
                    playAgainPressed()
                } label: {
                    Text("Play again")
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity)
                        .padding(.all, 15)
                }
                    .background(Color.myRed)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
            .padding()
            .background(Color.white)
            .frame(maxHeight: .infinity)
        }
        )
//        .edgesIgnoringSafeArea(.all)
    }
    
    func playAgainPressed() {
        game.reset()
            //shouldnt the above cause a refresh, since it's a state?
        //refresh parent VC
        isPresented = false
    }
}

struct OutcomeView_Previews: PreviewProvider {
    static var previews: some View {
        OutcomeView(isPresented: .constant(true), won: false)
            .environmentObject(Game.shared)
    }
}
