//
//  Constants.swift
//  ILSANG
//
//  Created by Lee Jinhee on 1/18/25.
//


import SwiftUI

struct Constants {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
}