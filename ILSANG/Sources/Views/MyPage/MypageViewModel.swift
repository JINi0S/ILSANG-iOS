//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import SwiftUI

final class MypageViewModel: ObservableObject {
    
    @Published var segmentSelect = 0
    
    @Published var userData: User?
    @Published var xpStats: [XpStat: Int] = [:]
    @Published var xpLogList: [XPContent] = []
    @Published var challengeList: [Challenge] = []
    
    @Published var challengeDelete = false
    
    let mockXpStats: [XpStat: Int] = [
        .strength: 0,
        .intellect: 50,
        .fun: 30,
        .charm: 20,
        .sociability: 30
    ]
    
    private let userNetwork: UserNetwork
    private let challengeNetwork: ChallengeNetwork
    private let imageNetwork: ImageNetwork
    private let xpNetwork: XPNetwork
    
    init(userData: User? = nil, userNetwork: UserNetwork, challengeNetwork: ChallengeNetwork, imageNetwork: ImageNetwork, xpNetwork: XPNetwork) {
        self.userData = userData
        self.userNetwork = userNetwork
        self.challengeNetwork = challengeNetwork
        self.imageNetwork = imageNetwork
        self.xpNetwork = xpNetwork
    }
    
    @MainActor
    func getUser() async {
        let res = await userNetwork.getUser()
        
        switch res {
        case .success(let model):
            self.userData = model.data
            Log(model.data)
            
        case .failure:
            self.userData = nil
            Log(res)
        }
    }
    
    @MainActor
    func getxpLog(page: Int, size: Int) async {
        let res = await xpNetwork.getXP(page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.xpLogList = model.data
            
        case .failure:
            self.xpLogList = []
            Log(res)
        }
    }
    
    @MainActor
    func getXpStat() async {
        let res = await xpNetwork.getXpStats()
        
        switch res {
        case .success(let model):
            let xpData = model.data
            self.xpStats = [
                .strength: xpData.strengthStat,
                .intellect: xpData.intellectStat,
                .fun: xpData.funStat,
                .charm: xpData.charmStat,
                .sociability: xpData.sociabilityStat
            ]
            Log(xpStats)
            
        case .failure:
            self.xpStats = [:]
        }
    }
    
    @MainActor
    func getChallenges(page: Int) async {
        let Data = await challengeNetwork.getChallenges(page: page)
        
        switch Data {
        case .success(let model):
            self.challengeList = model.data
            Log(self.challengeList)

        case .failure:
            self.challengeList = []
        }
    }
    
    @MainActor
    func updateChallengeStatus(challengeId: String, ImageId: String) async -> Bool {
        let deleteChallengeRes = await challengeNetwork.deleteChallenge(challengeId: challengeId)
        let deleteImageRes = await imageNetwork.deleteImage(imageId: ImageId)
        
        Log(deleteChallengeRes); Log(deleteImageRes)
        
        return deleteChallengeRes && deleteImageRes
    }
    
    //XP를 레벨로 변경
    func convertXPtoLv(XP: Int) -> Int {
        var totalXP = 0
        var level = 0
        
        while totalXP <= XP {
            level += 1
            totalXP += 50 * level
        }
        
        return max(0, level - 1)
    }
    
    //이전,다음 레벨 XP
    func xpGapBtwLevels(XP: Int) -> (currentLevelXP: Int, nextLevelXP: Int) {
        let sanitizedXP = max(0, XP)
        
        let currentLevel = convertXPtoLv(XP: sanitizedXP)
        let nextLevelXP = 50 * (currentLevel + 1)
        
        var totalXP = 0
        
        if currentLevel > 0 {
            for n in 1..<currentLevel + 1 {
                totalXP += 50 * n
            }
        }
        
        return (sanitizedXP - totalXP, nextLevelXP)
    }
    
    //다음 레벨까지 남은 값 
    func xpForNextLv(XP: Int) -> Int {
        let sanitizedXP = max(0, XP)
        let currentLevel = convertXPtoLv(XP: sanitizedXP)
        let nextLevel = currentLevel + 1
        var totalXP = 0
        
        for n in 1...nextLevel {
            totalXP += 50 * n
        }
        
        Log(totalXP)
        return totalXP - sanitizedXP
    }
    
    func getImage(imageId: String) async -> UIImage? {
        await ImageCacheService.shared.loadImageAsync(imageId: imageId)
    }
    
    func ProgressBar(userXP: Int) -> some View {
        let levelData = xpGapBtwLevels(XP: userXP)
        let progress = calculateProgress(userXP: levelData.currentLevelXP, levelXP: levelData.nextLevelXP)
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .cornerRadius(6)
                    .foregroundColor(.gray100)
                
                Rectangle()
                    .frame(width: CGFloat(progress) * geometry.size.width, height: 8)
                    .cornerRadius(6)
                    .foregroundColor(.accentColor)
            }
            .onAppear {
                Log("Progress: \(progress)")
                Log(self.xpGapBtwLevels(XP: userXP).currentLevelXP)
                Log(self.xpGapBtwLevels(XP: userXP).nextLevelXP)
            }
        }
    }
    
    func calculateProgress(userXP: Int, levelXP: Int) -> Double {
        guard levelXP != 0 else { return 0 }
        return Double(userXP) / Double(levelXP)
    }
    
    func PentagonGraph(xpStats: [XpStat: Int], width: CGFloat, mainColor: Color, subColor: Color, maxValue: Double = 50.0) -> some View {
        HStack {
            Spacer()
            
            ZStack {
                BackgroundPolygons(width: width, subColor: subColor) // 배경 오각형
                StatPolygon(xpStats: xpStats, maxValue: maxValue, cornerRadius: 15) // 데이터 오각형
                    .fill(mainColor)
                    .opacity(0.8)
                
                StatLabels(width: width, subColor: subColor) // 능력치 레이블
            }
            .frame(width: width, height: width)
            
            Spacer()
        }
    }

    // 배경 오각형 뷰
    func BackgroundPolygons(width: CGFloat, subColor: Color) -> some View {
        ForEach(1...5, id: \.self) { level in
            let relativeCornerRadius = CGFloat(0.20) // 각 꼭지점의 곡률 조절
            let scale = CGFloat(level) / 5.0
            Polygon(count: 5, relativeCornerRadius: relativeCornerRadius)
                .stroke(subColor, lineWidth: 1)
                .frame(width: width * scale, height: width * scale)
        }
    }

    // 능력치 레이블 위치 지정
    func StatLabels(width: CGFloat, subColor: Color) -> some View {
        ForEach(Array(XpStat.allCases.enumerated()), id: \.element) { index, stat in
            let angle = (CGFloat(index) / CGFloat(XpStat.allCases.count)) * 2 * .pi - .pi / 2
            let radius = width / 2 + 20 // 레이블을 표시할 위치의 반지름
            let labelPoint = CGPoint(
                x: width / 2 + radius * cos(angle),
                y: width / 2 + radius * sin(angle)
            )
            
            self.PentagonStat(xpStat: stat)
                .font(.caption)
                .foregroundColor(subColor)
                .position(x: labelPoint.x, y: labelPoint.y)
        }
    }

    // 능력치 레이블 뷰
    func PentagonStat(xpStat: XpStat) -> some View {
        HStack (spacing: 5) {
            Image(xpStat.image)
                .frame(height: 30)
            Text(xpStat.headerText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.gray500)
        }
    }
}

extension ChangeNickNameView {
    func isValidNickname(_ name: String) -> Bool {
        let Korean = ".*[가-힣].*"
        let English = ".*[a-zA-Z].*"
        let Number = ".*[0-9].*"
        
        let koreanMatch = NSPredicate(format: "SELF MATCHES %@", Korean).evaluate(with: name)
        let englishMatch = NSPredicate(format: "SELF MATCHES %@", English).evaluate(with: name)
        let numberMatch = NSPredicate(format: "SELF MATCHES %@", Number).evaluate(with: name)
        
        let isValidLength = (2...12).contains(name.count)
        
        return koreanMatch && englishMatch && numberMatch && isValidLength
    }
}
