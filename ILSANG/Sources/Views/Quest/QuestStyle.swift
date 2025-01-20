//
//  QuestStyle.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/29/24.
//

import SwiftUI

/// 퀘스트 스타일 프로토콜
protocol QuestStyleProtocol {
    var tagStyle: TagView.TagStyle? { get }
    var tagOffset: (x: CGFloat, y: CGFloat) { get }
    var imageSize: CGSize { get }
    var trailingPadding: CGFloat { get }
    var backgroundColor: Color { get }
    var isDisabled: Bool { get }
    
    associatedtype ItemView: View
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> ItemView
}

/// 퀘스트 스타일 프로토콜: 기본값 설정
extension QuestStyleProtocol {
    var tagOffset: (x: CGFloat, y: CGFloat) { (0, 0) }
    var imageSize: CGSize { CGSize(width: 60, height: 60) }
    var trailingPadding: CGFloat { 0 }
    var backgroundColor: Color { .white }
    var isDisabled: Bool { false }
}

protocol DefaultQuestStyleProtocol: QuestStyleProtocol {
    associatedtype TrailingView: View
    associatedtype OverlayView: View
   
    @ViewBuilder
    func trailingView()  -> TrailingView
   
    @ViewBuilder
    func overlayView()  -> OverlayView
}

struct UncompletedStyle: DefaultQuestStyleProtocol {
    var tagStyle: TagView.TagStyle? { .xp }
    var tagOffset: (x: CGFloat, y: CGFloat) { (48, 5) }
    var trailingPadding: CGFloat { 20 }
        
    func trailingView() -> some View {
        IconView(iconWidth: 6, size: .small, icon: .arrowRight, color: .gray)
    }
    
    func overlayView() -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        DefaultQuestView(quest: quest, style: UncompletedStyle())
    }
}

struct CompletedStyle: DefaultQuestStyleProtocol {
    static let separatorOffset: CGFloat = 72.0

    var tagStyle: TagView.TagStyle? { .xp }
    var tagOffset: (x: CGFloat, y: CGFloat) { (48, 5) }
    var isDisabled: Bool { true }
    
    @ViewBuilder
    func trailingView() -> some View {
        VStack(spacing: 7) {
            IconView(iconWidth: 13, size: .small, icon: .check, color: .green)
            Text("적립완료")
                .font(.system(size: 12, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.green)
        }
        .frame(width: CompletedStyle.separatorOffset)
    }

    @ViewBuilder
    func overlayView() -> some View {
        VLine()
            .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [3.3]))
            .frame(width: 0.5)
            .foregroundStyle(.gray200)
            .offset(x: -CompletedStyle.separatorOffset)
            .padding(.vertical, 12)
    }
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        DefaultQuestView(quest: quest, style: CompletedStyle())
    }
}

struct RepeatStyle: DefaultQuestStyleProtocol {
    let repeatType: RepeatType

    var tagStyle: TagView.TagStyle? { .repeat(repeatType) }
    var tagOffset: (x: CGFloat, y: CGFloat) { (54, 3) }
    var trailingPadding: CGFloat { 20 }
    
    func trailingView() -> some View {
        IconView(iconWidth: 6, size: .small, icon: .arrowRight, color: .gray)
    }
    
    func overlayView() -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        DefaultQuestView(quest: quest, style: RepeatStyle(repeatType: repeatType))
    }
}


struct RecommendStyle: QuestStyleProtocol {
    var tagStyle: TagView.TagStyle? { nil }
    var tagOffset: (x: CGFloat, y: CGFloat) { (16, 16) }
    var imageSize: CGSize { CGSize(width: 64, height: 64)}
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        RecommendQuestView(quest: quest, style: RecommendStyle())
    }
}

struct PopularStyle: QuestStyleProtocol {
    let repeatType: RepeatType
    
    var tagStyle: TagView.TagStyle? { .repeat(repeatType) }
    var tagOffset: (x: CGFloat, y: CGFloat) { (16, 16) }
    var imageSize: CGSize { CGSize(width: (UIScreen.main.bounds.width - 40 - 2) / 2, height: 137)}
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        PopularQuestView(quest: quest, style: PopularStyle(repeatType: repeatType))
    }
}

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
