//
//  Icon.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/23/24.
//

import SwiftUI

struct IconView: View {
    let iconWidth: CGFloat
    let size: IconSize
    let icon: ImageResource
    let color: IconColor
    
    var body: some View {
        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth)
            .offset(x: icon == .arrowRight ? 1 : 0)
            .foregroundStyle(color.fgColor)
            .frame(width: size.value, height: size.value)
            .background(
                Circle()
                    .foregroundStyle(color.bgColor)
            )
    }
}

