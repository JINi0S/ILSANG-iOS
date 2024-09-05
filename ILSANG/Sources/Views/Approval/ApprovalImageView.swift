//
//  ApprovalImageView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/2/24.
//

import SwiftUI

struct ApprovalImageView: View {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    let nickname: String
    let time: String
    let showProfile: Bool
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.4)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 268)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(alignment: .bottomLeading) {
                if showProfile {
                    profileView(nickname: nickname, time: time)
                }
            }
    }
    
    private func profileView(nickname: String, time: String) -> some View {
        HStack(spacing: 10) {
            Image(.profileCircle)
                .resizable()
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(nickname)
                    .font(.system(size: 14, weight: .semibold))
                Text(time)
                    .font(.system(size: 12, weight: .regular))
            }
            .foregroundStyle(.white)
        }
        .padding(.leading, 16)
        .padding(.bottom, 26)
    }
}
