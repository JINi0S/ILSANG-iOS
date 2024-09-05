//
//  XP.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/21/24.
//

import Foundation

struct XPModel: Decodable {
    let data: XP
}

struct XP: Decodable {
    let size: Int
    let data: [XPContent]
    let total: Int
    let page: Int
    let status: String
    let message: String
}

struct XPContent: Decodable {
    let recordId: Int
    let title: String
    let xpPoint: Int
    let createDate: String
}
