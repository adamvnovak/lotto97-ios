//
//  InfoView.swift
//  lotto97
//
//  Created by Adam Novak on 2022/12/03.
//

import SwiftUI

struct InfoView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        Color.myRed.edgesIgnoringSafeArea(.vertical).overlay(
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("Lotto 97")
                .font(MyFont.title)
                .fontWeight(.bold)
            Text("An eductional game about the 1997 Asian financial crisis\n\nInspired by the 2013 film \"Ilo Ilo\" directed by Anthony Chen\n\nCreated by Adam Novak, Dec 2022\n\nCopyright @LeaveyLabs Inc.")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Link("lotto97.xyz", destination: URL(string: "https://lotto97.xyz")!)
            Spacer()
            Button {
                dismissPressed()
            } label: {
                Text("Dismiss")
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .font(.system(size: 20))
                    .foregroundColor(.myRed)
            }
            .background(Color.white)
            .shadow(radius: 5)
            .cornerRadius(20)
        }
        .font(.system(size: 20))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.myRed)
        .foregroundColor(.white)
    )}
    
    func dismissPressed() {
        isPresented = false
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresented: .constant(true))
    }
}
