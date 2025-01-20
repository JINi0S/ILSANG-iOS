//
//  UIDevice.swift
//  ILSANG
//
//  Created by Lee Jinhee on 10/28/24.
//

import UIKit

extension UIDevice {
    static var isSEDevice: Bool = checkIfSEDevice()
    
    private static func checkIfSEDevice() -> Bool {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height == 20
    }
}
