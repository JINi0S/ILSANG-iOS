//
//  QuestItemView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import SwiftUI

// 공통 데이터 구조
struct QuestCommonComponent {
    let title: String
    let writer: String
    let rewardDic: [XpStat: Int]
    let image: UIImage?
    let tagTitle: String
    let action: (() -> Void)?
}

struct QuestItemView: View {
    let component: QuestCommonComponent
    let style: QuestStyle
    
    init(style: QuestStyle, quest: QuestViewModelItem, tagTitle: String, action: @escaping () -> Void) {
        self.component = QuestCommonComponent(
            title: quest.missionTitle,
            writer: quest.writer,
            rewardDic: quest.rewardDic,
            image: quest.image,
            tagTitle: tagTitle,
            action: action
        )
        self.style = style
    }
    
    var body: some View {
        Button(action: { component.action?() }) {
            HStack(spacing: 0) {
                QuestImageWithTagView(
                    image: component.image,
                    tagTitle: component.tagTitle,
                    tagStyle: style.tagStyle,
                    tagOffset: style.tagOffset
                )
                .padding(.trailing, 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(component.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(component.writer)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray400)
                        .padding(.bottom, 4)
                    
                    StatGridView(rewardDic: component.rewardDic)
                }
                
                Spacer()
                
                style.trailingView()
            }
            .padding(20)
            .background(style.backgroundColor)
            .cornerRadius(12)
            .shadow(color: .shadow7D.opacity(0.05), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .disabled(style.isDisabled)
    }
}

// 스타일 관리
enum QuestStyle {
    case uncompleted
    case completed
    case repeatable(RepeatType)
    
    var tagStyle: TagView.TagStyle {
        switch self {
        case .uncompleted: return .xp
        case .completed: return .xp
        case .repeatable(let repeatType): return .repeat(repeatType)
        }
    }
    
    var tagOffset: (x: CGFloat, y: CGFloat) {
        switch self {
        case .uncompleted, .completed:
            return (x: 48, y: 5)
        case .repeatable:
            return (x: 54, y: 3)
        }
    }
    
    @ViewBuilder
    func trailingView() -> some View {
        switch self {
        case .uncompleted, .repeatable:
            IconView(iconWidth: 6, size: .small, icon: .arrowRight, color: .gray)
        case .completed:
            VStack(spacing: 7) {
                IconView(iconWidth: 13, size: .small, icon: .check, color: .green)
                Text("적립완료")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.green)
            }
            .frame(width: 72)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .completed: return Color.white
        default: return Color.white
        }
    }
    
    var isDisabled: Bool {
        switch self {
        case .completed: return true
        default: return false
        }
    }
}
