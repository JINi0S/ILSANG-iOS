//
//  MyPageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import UIKit

@MainActor
final class MyPageViewModel: ObservableObject {
    @Published var userData: User?
    @Published var selectedTab: MyPageTab = .quest
    
    @Published var xpStats: [XpStat: Int] = [:]
    @Published var xpLogList: [XpLog] = []
    @Published var challengeList: [(challenge: Challenge, image: UIImage?)] = [] // [(Challenge.challengeMockData, nil)]
    
    @Published var challengeDelete = false
    
    private let userNetwork: UserNetwork
    private let challengeNetwork: ChallengeNetwork
    private let imageNetwork: ImageNetwork
    private let xpNetwork: XPNetwork
    
    init(userNetwork: UserNetwork, challengeNetwork: ChallengeNetwork, imageNetwork: ImageNetwork, xpNetwork: XPNetwork) {
        self.userNetwork = userNetwork
        self.challengeNetwork = challengeNetwork
        self.imageNetwork = imageNetwork
        self.xpNetwork = xpNetwork
        
        self.userData = UserService.shared.currentUser
    }
    
    @MainActor
    func getUser() async {
        let res = await userNetwork.getUser()
        
        switch res {
        case .success(let model):
            self.userData = model.data
        case .failure(let err):
            self.userData = nil
            Log(err)
        }
    }
    
    @MainActor
    func getXpLog(page: Int, size: Int) async {
        let res = await xpNetwork.getXpHistory(page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.xpLogList = model.data
            
        case .failure(let err):
            self.xpLogList = []
            Log(err)
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
        case .failure(let error):
            Log("XP 스탯 조회 실패: \(error)")
            self.xpStats = [:]
        }
    }
    
    @MainActor
    func fetchChallengesWithImages(page: Int) async {
        let response = await challengeNetwork.getChallenges(page: page)
        
        switch response {
        case .success(let model):
            // 데이터 초기화: 이미지가 없는 상태로 미리 표시
            self.challengeList = model.data.map { ($0, nil as UIImage?) }
            
            await withTaskGroup(of: Void.self) { group in
                for (index, challenge) in model.data.enumerated() {
                    group.addTask {
                        let image = await self.getImage(imageId: challenge.receiptImageId)
                        await self.updateChallengeImage(at: index, with: image)
                    }
                }
            }
            
        case .failure(let error):
            Log("챌린지 조회 실패: \(error)")
            self.challengeList = []
        }
    }
    
    @MainActor
    private func updateChallengeImage(at index: Int, with image: UIImage?) {
        if index < self.challengeList.count {
            self.challengeList[index].1 = image
        }
    }
    
    @MainActor
    func updateChallengeStatus(challengeId: String, ImageId: String) async -> Bool {
        let deleteChallengeRes = await challengeNetwork.deleteChallenge(challengeId: challengeId)
        let deleteImageRes = await imageNetwork.deleteImage(imageId: ImageId)
        
        return deleteChallengeRes && deleteImageRes
    }
    
    func getImage(imageId: String) async -> UIImage? {
        await ImageCacheService.shared.loadImageAsync(imageId: imageId)
    }
}
