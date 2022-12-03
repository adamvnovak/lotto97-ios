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
        VStack(alignment: .center, spacing: 20) {
            Spacer()
            Text("Lotto 97")
                .font(MyFont.title)
                .fontWeight(.bold)
            Text("An educational game inspired by the film Ilo Ilo.")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            Text("Created by Adam Novak, Dec 2022")
                .multilineTextAlignment(.center)
            Text("Copyright @LeaveyLabs Inc.")
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                dismissPressed()
            } label: {
                Text("Dismiss")
                    .frame(maxWidth: .infinity)
                    .padding(10)
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
    }
    
    func dismissPressed() {
        isPresented = false
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresented: .constant(true))
    }
}
