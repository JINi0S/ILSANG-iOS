//
//  XP.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

struct XpLog: Decodable {
    let recordId: Int
    let title: String
    let xpPoint: Int
    let createDate: String
    
    static let mockDataList = [
        XpLog(recordId: 1, title: "Mission Accomplished", xpPoint: 100, createDate: "2024-06-21"),
        XpLog(recordId: 2, title: "Daily Login", xpPoint: 50, createDate: "2024-06-22"),
        XpLog(recordId: 3, title: "Quest Completed", xpPoint: 150, createDate: "2024-06-23")
    ]
}
