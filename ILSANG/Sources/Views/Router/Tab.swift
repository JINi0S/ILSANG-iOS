//
//  Tab.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

enum Tab: CaseIterable {
    case quest
    case approval
    case mypage
    
    var icon: String {
        switch self {
        case .quest:
            return "quest"
        case .approval:
            return "approval.circle"
        case .mypage:
            return "profile"
        }
    }
    
    var selectedIcon: String {
        icon + ".fill"
    }
    
    var title: String {
        switch self {
        case .quest:
            return "퀘스트"
        case .approval:
            return "인증"
        case .mypage:
            return "마이"
        }
    }
}
