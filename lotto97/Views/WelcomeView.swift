//
//  WelcomeView.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/02.
//

import SwiftUI

struct WelcomeView: View {
    @State var infoPresented: Bool = false
    var bodyText: String {
        "You are a Singaporean family of 3 in the 1997 financial crisis.\n\nYour goal is to make it through without going bankrupt or losing any family members."
    }
    
    var body: some View {
        Color.myRed
            .edgesIgnoringSafeArea(.top)
            .overlay (
        VStack(alignment: .center, spacing: 20) {
            VStack(spacing: 5) {
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
                }
                .padding(.top, 10)
                Spacer()
                Text("Lotto 97")
                    .font(MyFont.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Choose your own hardship")
                    .font(MyFont.bigbody)
                    .fontWeight(.bold)
                    .padding([.horizontal], 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.myRed)
            VStack {
                Text(bodyText)
                    .font(MyFont.body)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button {
                    beginPressed()
                } label: {
                    NavigationLink {
                        GameView()
                    } label: {
                        Text("Begin")
                            .font(.system(size: 22))
                            .frame(maxWidth: .infinity)
                            .padding(.all, 10)
                    }
                }
                .background(Color.myRed)
                .foregroundColor(.white)
                .cornerRadius(20)
//                .padding()
                .shadow(radius: 5)
            }
            .padding()
            .background(Color.white)
            .frame(maxHeight: .infinity)
        }
//        .edgesIgnoringSafeArea(.all)
        )
    }
    
    func beginPressed() {
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
