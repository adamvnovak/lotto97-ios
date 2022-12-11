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
    @State var infoPresented: Bool = false
    @StateObject var device = DeviceService.shared

    var won: Bool
    var titleText: String {
        won ? "Congratulations!" : "Tough luck."
    }
    var bodyText: String {
        won ? "You made it through the 1997 Asian financial crisis without losing family members or going bankrupt.\n\n"
        : "Your family didn't make it through the 1997 Asian financial crisis."
    }
    
    var body: some View {
        Color.myRed
            .edgesIgnoringSafeArea(.top)
            .overlay (
        VStack(alignment: .center, spacing: 20) {
            VStack {
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
                .padding(.top, 10)
                .padding([.trailing,.leading], 25)
                Spacer()
                Text(titleText)
                    .font(MyFont.title)
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            VStack (alignment: .leading) {
                Text(bodyText)
                    .font(MyFont.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                if won {
                    Link("Learn more about the crisis", destination: URL(string: "https://en.wikipedia.org/wiki/1997_Asian_financial_crisis#:~:text=The%20Asian%20financial%20crisis%20was,worries%20of%20a%20meltdown%20subsided.")!)
                        .font(MyFont.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.trailing)
                    Link("Watch the 2013 film \"Ilo Ilo\"", destination: URL(string: "https://www.kanopy.com/en/product/132220")!)
                        .font(MyFont.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                }
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
            .onAppear {
                if won {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        guard isPresented else { return }
                        AppStoreReviewManager.requestReviewIfAppropriate()
                    }
                }
            }
        )
//        .edgesIgnoringSafeArea(.all)
    }
    
    func playAgainPressed() {
        DeviceService.shared.didTry()
        game.reset()
        isPresented = false
    }
}

struct OutcomeView_Previews: PreviewProvider {
    static var previews: some View {
        OutcomeView(isPresented: .constant(true), won: true)
            .environmentObject(Game.shared)
    }
}
