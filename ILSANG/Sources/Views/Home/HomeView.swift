//
//  HomeView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/21/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel = HomeViewModel(questNetwork: QuestNetwork(), rankNetwork: RankNetwork())
    @EnvironmentObject var sharedState: SharedState
    @Environment(\.redactionReasons) var redactionReasons
    
    private let gridItem = [GridItem(), GridItem()]
    
    private struct LayoutConstants {
        static let sectionSpacing: CGFloat = 36
        static let vStackSpacing: CGFloat = 26
        static let lazyHGridSpacing: CGFloat = 9
        static let horizontalPadding: CGFloat = 20
        static let tabViewHeight: CGFloat = 450
        static let paginationSpacing: CGFloat = 4
        static let circleSize: CGFloat = 10
    }
    
    var body: some View {
        Group {
            switch vm.viewStatus {
            case .loading, .loaded:
                ScrollView {
                    VStack(spacing: 23) {
                        header
                        content
                    }
                }
                .refreshable {
                    await vm.loadInitialData()
                }
                .disabled(vm.viewStatus == .loading)
            case .error:
                networkErrorView
            }
        }
        .background(Color.background)
        .sheet(isPresented: $vm.showQuestSheet) {
            QuestDetailView(quest: vm.selectedQuest) {
                vm.onQuestApprovalTapped()
            }
            .presentationDetents([.height(464)])
            .presentationDragIndicator(.hidden)
        }
        .fullScreenCover(isPresented: $vm.showSubmitRouterView) {
            SubmitRouterView(selectedQuest: vm.selectedQuest)
                .interactiveDismissDisabled()
        }
    }
    
    private var header: some View {
        HStack(alignment: .bottom) {
            Image(.logoWithAlpha)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                sharedState.selectedTab = .mypage /// 마이 탭으로 이동
            } label: {
                Image(.profileCircle)
                    .resizable()
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, LayoutConstants.horizontalPadding)
    }
    
    private var content: some View {
        LazyVStack(spacing: LayoutConstants.sectionSpacing) {
            // TODO: 메인 배너 섹션
            if vm.showPopularRewardQuest {
                popularQuestSection
            }
            if vm.showRecommendRewardQuest {
                recommendQuestSection
            }
            if vm.showLargestRewardQuest {
                largestRewardQuestSection
            }
            if vm.showRankList {
                userRankingSection
            }
        }
        .padding(.bottom, 72)
        .redacted(reason: vm.viewStatus == .loading ? .placeholder : [])
        .foregroundStyle(redactionReasons.contains(.placeholder) ? .clear: Color.gray500)
    }
    
    private var popularQuestSection: some View {
        TitleWithContentView(
            title: "이번 달 인기 퀘스트 모음",
            content: popularQuestSectionContent
        )
    }
    
    @ViewBuilder
    private var popularQuestSectionContent: some View {
        if vm.popularQuestList.count <= vm.popularChunkSize {
            singlePageContent
        } else {
            multiPageContent
        }
    }
    
    private var singlePageContent: some View {
        LazyHGrid(rows: gridItem, alignment: .top, spacing: LayoutConstants.lazyHGridSpacing) {
            ForEach(vm.popularQuestList) { quest in
                QuestItemView(
                    quest: quest,
                    style: PopularStyle(repeatType: RepeatType(rawValue: quest.target.lowercased()) ?? .daily),
                    tagTitle: "\(quest.totalRewardXP())XP"
                ) {
                    vm.onQuestTapped(quest: quest)
                }
            }
        }
        .padding(.horizontal, LayoutConstants.horizontalPadding)
    }
    
    private var multiPageContent: some View {
        VStack(spacing: LayoutConstants.vStackSpacing) {
            TabView(selection: $vm.selectedPopularTabIndex) {
                ForEach(vm.paginatedPopularQuests.indices, id: \.self) { pageIndex in
                    LazyHGrid(rows: gridItem, alignment: .top, spacing: LayoutConstants.lazyHGridSpacing) {
                        ForEach(vm.paginatedPopularQuests[pageIndex]) { quest in
                            QuestItemView(
                                quest: quest,
                                style: PopularStyle(repeatType: RepeatType(rawValue: quest.target.lowercased()) ?? .daily),
                                tagTitle: "\(quest.totalRewardXP())XP"
                            ) {
                                vm.onQuestTapped(quest: quest)
                            }
                        }
                    }
                    .padding(.horizontal, LayoutConstants.horizontalPadding)
                    .tag(pageIndex)
                }
            }
            .frame(height: LayoutConstants.tabViewHeight)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            paginationIndicator
        }
    }
    
    private var paginationIndicator: some View {
        HStack(spacing: LayoutConstants.paginationSpacing) {
            let pageCount = Int(vm.popularQuestList.count / vm.popularChunkSize)
            if pageCount >= 2 {
                ForEach(0..<pageCount, id: \.self) { index in
                    Circle()
                        .frame(width: LayoutConstants.circleSize, height: LayoutConstants.circleSize)
                        .foregroundStyle(index == vm.selectedPopularTabIndex ? Color.gray500 : Color.gray100)
                        .animation(.default, value: index)
                }
            }
        }
    }
    
    private var recommendQuestSection: some View {
        TitleWithContentView(
            title: vm.recommendQuestTitle,
            content:
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(vm.recommendQuestList, id: \.id) { quest in
                            QuestItemView(
                                quest: quest,
                                style: RecommendStyle()) {
                                    vm.onQuestTapped(quest: quest)
                                }
                        }
                    }
                    .padding(.horizontal, LayoutConstants.horizontalPadding)
                }
                .scrollIndicators(.hidden)
        )
    }
    
    private var largestRewardQuestSection: some View {
        TitleWithContentView(
            title: "큰 보상 퀘스트",
            seeAll: (
                .label("전체 보기"),
                .bottomTrailing, {
                    sharedState.selectedXpStat = vm.selectedXpStat
                    sharedState.selectedTab = .quest /// 퀘스트 탭(선택된 스탯)으로 이동
                }
            ),
            content:
                Group {
                    StatHeaderView(
                        selectedXpStat: $vm.selectedXpStat,
                        horizontalPadding: LayoutConstants.horizontalPadding,
                        height: 30,
                        hasBottomLine: false
                    )
                    // TODO: (디자인 대기 중) 퀘스트 타입에 따라 다르게 보여줘야함
                    ForEach(vm.largestRewardQuestList[vm.selectedXpStat, default: []].prefix(3), id: \.id) { quest in
                        QuestItemView(
                            quest: quest,
                            style: UncompletedStyle(),
                            tagTitle: String(quest.totalRewardXP())+"XP"
                        ) {
                            vm.onQuestTapped(quest: quest)
                        }
                    }
                }
        )
    }
    
    private var userRankingSection: some View {
        TitleWithContentView(
            title: "유저 랭킹",
            seeAll: (
                .icon,
                .topTrailing, {
                    sharedState.selectedTab = .ranking /// 랭킹탭 이동
                }
            ),
            content:
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(Array(vm.userRankList.enumerated()), id: \.offset) { idx, rank in
                            RankingItemView(topRank: rank, style: .vertical)
                        }
                    }
                    .padding(.horizontal, LayoutConstants.horizontalPadding)
                }
                .scrollIndicators(.never)
        )
    }
    
    private var networkErrorView: some View {
        ErrorView(
            systemImageName: "wifi.exclamationmark",
            title: "네트워크 연결 상태를 확인해주세요",
            subTitle: "네트워크 연결 상태가 좋지 않아\n정보를 불러올 수 없어요 ",
            emoticon: "🥲"
        ) {
            Task { await vm.loadInitialData() }
        }
    }
}

#Preview {
    HomeView()
}

extension Array {
    func chunks(of chunkSize: Int) -> [[Element]] {
        stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, count)])
        }
    }
}
