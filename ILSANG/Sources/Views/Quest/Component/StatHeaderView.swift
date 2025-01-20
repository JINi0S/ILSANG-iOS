//
//  StatHeaderView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/29/24.
//

import SwiftUI

struct StatHeaderView: View {
    @Binding var selectedXpStat: XpStat
    let horizontalPadding: CGFloat
    let height: CGFloat
    let hasBottomLine: Bool
    
    @Namespace private var namespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if hasBottomLine {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray100)
            }
            HStack(spacing: 0) {
                ForEach(XpStat.allCases) { xpStat in
                    let isSelected = xpStat == selectedXpStat
                    
                    Button {
                        selectedXpStat = xpStat
                    } label: {
                        Text(xpStat.headerText)
                            .foregroundColor(isSelected ? .gray500 : .gray300)
                            .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                            .frame(height: height)
                    }
                    .padding(.horizontal, 7)
                    .overlay(alignment: .bottom) {
                        if isSelected {
                            Rectangle()
                                .frame(height: 3)
                                .foregroundStyle(.primaryPurple)
                                .matchedGeometryEffect(id: "XpStat", in: namespace)
                        }
                    }
                    .animation(.easeInOut, value: selectedXpStat)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
}

#Preview {
    VStack {
        // 홈뷰
        StatHeaderView(selectedXpStat: .constant(XpStat.fun), horizontalPadding: 20, height: 30, hasBottomLine: false)
        // 퀘스트뷰
        StatHeaderView(selectedXpStat: .constant(XpStat.intellect), horizontalPadding: 0, height: 44, hasBottomLine: true)
    }
}
