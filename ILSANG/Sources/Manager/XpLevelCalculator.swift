//
//  XpLevelCalculator.swift
//  ILSANG
//
//  Created by Lee Jinhee on 1/10/25.
//

import Foundation

struct XpLevelCalculator {
    
    // 음수 방지 처리
    private static func sanitizeInput(_ value: Int) -> Int {
        return max(0, value)
    }
    
    // 특정 레벨까지 누적된 XP 계산
    private static func calculateAccumulatedXP(forLevel level: Int) -> Int {
        return (0...level).reduce(0) { $0 + 50 * $1 }
    }
    
    //XP를 레벨로 변경
    static func convertXPtoLv(xp: Int?) -> Int {
        guard let xp = xp, xp != 0 else { return 0 }
        let clampedXP = sanitizeInput(xp)
        var totalXP = 0
        var level = 0
        
        while totalXP <= clampedXP {
            level += 1
            totalXP += 50 * level
        }
        
        return max(0, level - 1)
    }
    
    // 현재 레벨의 진행 상황 - 현재 레벨에서 얻은 XP, 다음 레벨까지 필요한 전체 XP
    static func xpProgressInCurrentLevel(xp: Int, level currentLevel : Int) -> (currentLevelXP: Int, requiredXPForNextLevel: Int) {
        let clampedXP = sanitizeInput(xp)
        let accumulatedXP = calculateAccumulatedXP(forLevel: currentLevel)
        let requiredXPForNextLevel = 50 * (currentLevel + 1) // 다음 레벨까지 필요한 XP
        
        return (clampedXP - accumulatedXP, requiredXPForNextLevel)
    }
    
    //다음 레벨까지 남은 값
    static func xpForNextLv(xp: Int) -> Int {
        let clampedXP = sanitizeInput(xp)
        let currentLevel = convertXPtoLv(xp: clampedXP)
        let nextLevel = currentLevel + 1
        let requiredXP = calculateAccumulatedXP(forLevel: nextLevel)
        
        return requiredXP - clampedXP
    }
    
    static func calculateProgress(currentValue: Int, totalValue: Int) -> Double {
        guard totalValue != 0 else { return 0 }
        return Double(currentValue) / Double(totalValue)
    }
}
