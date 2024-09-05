//
//  Quest.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/18/24.
//

struct Quest: Codable {
    let questId: String
    let writer: String
    let quantity: Int
    let missionTitle: String
    let status: String
    let creatorRole: String
    let imageId: String?
}
