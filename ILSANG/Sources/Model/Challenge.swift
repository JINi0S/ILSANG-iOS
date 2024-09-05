//
//  Challenge.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/26/24.
//

import Foundation

// TODO: userNickName, quest 옵셔널 해제
struct Challenge: Codable {
    let challengeId: String
    let userNickName: String?
    let quest: QuestEntity?
    let receiptImageId, status: String
    let createdAt: String
    let likeCnt, hateCnt: Int
}

/// 서버에서 사용되는 Quest Entity
struct QuestEntity: Codable {
    let questId: String
    let missions: [Mission]
    let rewards: [Reward]
}

struct Mission: Codable {
    let content: String
    let target: String?
    let quantity: Int
    let type, title: String
}

struct Reward: Codable {
    let quantity: Int
    let type: String
}
