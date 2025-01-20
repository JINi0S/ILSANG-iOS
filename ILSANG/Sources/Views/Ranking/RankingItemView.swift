//
//  RankingItemView.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import SwiftUI

struct Rank {
    let idx: Int
    let nickname: String
    var xpType: String? = nil
    let score: Int
}

struct RankingItemView: View {
    let rank: Rank
    let style: RankingItemStyle
    
    enum RankingItemStyle {
        case horizontal
        case vertical
    }
    
    init(topRank: TopRank, style: RankingItemStyle) {
        self.rank = Rank(idx: topRank.lank, nickname: topRank.nickname, score: topRank.xpSum)
        self.style = style
    }
    
    init(idx: Int, statRank: StatRank, style: RankingItemStyle) {
        self.rank = Rank(idx: idx, nickname: statRank.nickname, xpType: statRank.xpType, score: statRank.xpPoint)
        self.style = style
    }
    
    var body: some View {
        switch style {
        case .horizontal:
            RankingHorizontalItemView(rank: rank)
        case .vertical:
            RankingVerticalItemView(rank: rank)
        }
    }
}

fileprivate struct RankingHorizontalItemView: View {
    let rank: Rank
    
    var body: some View {
        HStack(spacing: 0) {
            // 랭킹 아이콘 & 순위
            let idx = rank.idx
            if idx <= 3 {
                Image("rank\(idx)")
                    .resizable()
                    .frame(width: 26, height: 26)
            } else {
                Text("\(idx)")
                    .frame(width: 26, height: 26, alignment: .center)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.gray500)
            }
            
            Text("😍")
                .font(.system(size: 23, weight: .bold))
                .frame(width: 48, height: 48)
                .background(
                    Circle().fill(Color.backgroundBlue)
                )
                .padding(.horizontal, UIDevice.isSEDevice ? 16 : 24)
            
            VStack (alignment: .leading, spacing: 4) {
                Text(rank.nickname)
                    .font(.system(size: 15, weight: .bold))
                
                if let xpType = rank.xpType {
                    Text("\(convertStat(xpType)) : \(rank.score)p")
                        .font(.system(size: 13))
                        .foregroundColor(.gray400)
                } else {
                    Text("\(rank.score)p")
                        .font(.system(size: 13))
                        .foregroundColor(.gray400)
                }
            }
            
            Spacer(minLength: 0)
            
            // MARK: API 수정 후 태그뷰 추가
        }
        .padding(.horizontal, UIDevice.isSEDevice ? 20 : 24)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}

extension RankingHorizontalItemView {
    //XpStat 한글 변환
    func convertStat(_ xpType: String) -> String {
        let typeMapping: [String: String] = [
            "STRENGTH": "체력",
            "INTELLECT": "지능",
            "FUN": "재미",
            "CHARM": "매력",
            "SOCIABILITY": "사회성"
        ]
    
        return typeMapping[xpType] ?? xpType
    }
}


fileprivate struct RankingVerticalItemView: View {
    let rank: Rank
    
    var body: some View {
        VStack(spacing: 6) {
            Text("😍")
                .font(.system(size: 23, weight: .bold))
                .frame(width: 64, height: 64)
                .background(
                    Circle().fill(Color.backgroundBlue)
                )
                .padding(6)
            
            // 랭킹 아이콘 & 순위
            let idx = rank.idx
            if idx <= 3 {
                Image("rank\(idx)")
                    .resizable()
                    .frame(width: 24, height: 24)
            } else {
                Text("\(idx)")
                    .frame(width: 24, height: 24, alignment: .center)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.gray500)
            }
            
            Text(rank.nickname)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
            
            Text("\(rank.score)xp")
                .font(.system(size: 13))
                .foregroundColor(.gray500)
        }
        .frame(width: 150)
        .padding(.vertical, 17)
        .background(.white)
        .cornerRadius(12)
    }
}
