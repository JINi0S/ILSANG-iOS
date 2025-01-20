//
//  StatGridView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/1/24.
//

import SwiftUI

struct StatGridView: View {
    let rewardDic: [XpStat: Int]
    
    var body: some View {
        if rewardDic.filter({ $0.value > 0 }).count <= 3 {
            tagView(range: 0..<5)
        } else if rewardDic.filter({ $0.value > 0 }).count == 4 {
            VStack(alignment: .leading, spacing: 4) {
                tagView(range: 0..<4) // 0 1 2 3
                tagView(range: 4..<5) // 4
            }
        } else {
            VStack(alignment: .leading, spacing: 4) {
                tagView(range: 0..<3) // 0 1 2
                tagView(range: 3..<5) // 3 4
            }
        }
    }
    
    private func tagView(range: Range<Int>) -> some View {
        HStack(spacing: 4) {
            ForEach(Array(XpStat.sortedStat[range]), id: \.rawValue) { stat in
                let reward = rewardDic[stat, default: 0]
                if reward > 0 {
                    TagView(title: "\(reward)P", image: stat.image, tagStyle: .xpWithIcon)
                }
            }
        }
    }
}


#Preview {
    StatGridView(rewardDic: [.charm: 225, .fun: 0, .intellect: 392, .strength: 20, .sociability: 20])
        .padding(.horizontal, 20)
}
