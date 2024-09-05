//
//  GoogleLoginButtonView.swift
//  TeamFair
//
//  Created by apple on 2023/07/27.
//

import SwiftUI

struct GoogleLoginButtonView: View {
    var buttonAction:  () -> ()
    
    var body: some View {
        Button(action: buttonAction) {
            HStack {
                Image(LoginButton.google.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                Spacer()
                Text(LoginButton.google.labelText)
                    .foregroundColor(LoginButton.google.accentColor)
                    .font(.custom(LoginButton.google.fontName, size: 14))
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .frame(width: 270, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(Color.gray200)
                    .background(LoginButton.google.backgroundColor)
                    .cornerRadius(16, corners: .allCorners)
            )
        }
    }
}


struct GoogleLoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginButtonView(buttonAction: {})
    }
}
