//
//  ContentView.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/02.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: Game = Game.shared
    
    var body: some View {
        NavigationView {
            WelcomeView()
        }
        .navigationViewStyle(.stack)
        .environmentObject(game)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
