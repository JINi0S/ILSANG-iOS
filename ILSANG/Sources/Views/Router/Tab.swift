//
//  Tab.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

enum Tab: CaseIterable {
    case home
    case quest
    case approval
    case ranking
    case mypage
    
    var icon: String {
        switch self {
        case .home:
            return "home"
        case .quest:
            return "quest"
        case .approval:
            return "approval.circle"
        case .ranking:
            return "rank"
        case .mypage:
            return "profile"
        }
    }
    
    var selectedIcon: String {
        icon + ".fill"
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .quest:
            return "퀘스트"
        case .approval:
            return "인증"
        case .ranking:
            return "랭킹"
        case .mypage:
            return "마이"
        }
    }
}
