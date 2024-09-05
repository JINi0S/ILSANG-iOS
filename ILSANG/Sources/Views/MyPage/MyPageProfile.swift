//
//  MyPageProfile.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/23/24.
//

import SwiftUI

struct MyPageProfile: View {
    
    @StateObject var vm = MypageViewModel(userNetwork: UserNetwork(),xpNetwork: XPNetwork(), challengeNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork())
    
    var body: some View {
        NavigationLink(destination: ChangeNickNameView()) {
            HStack {
                //프로필
                ProfileImageView(profileImage: nil, level: vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9))
                
                // 프로필 상세
                VStack (alignment: .leading) {
                    //유저 이름
                    Text(vm.userData?.nickname ?? "일상73079405")
                        .font(.system(size: 16, weight: .bold))
                        .underline(true, color: .gray300)
                        .foregroundStyle(.gray500)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        // 프로그레스 바
                        vm.ProgressBar(userXP: vm.userData?.xpPoint ?? 0)
                            .frame(height: 10)
                        
                        // 경험치 Text
                        Text(String(vm.userData?.xpPoint ?? 0)+"XP")
                            .font(.system(size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                    
                    Text("다음 레벨까지 \(vm.xpForNextLv(XP: vm.userData?.xpPoint ?? 50))XP 남았어요!")
                        .font(.system(size: 13))
                        .foregroundColor(.gray500)
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.white)
            )
            .task {
                await vm.getUser()
                Log(vm.userData)
            }
        }
    }
}

struct ProfileImageView: View {
    var ProfileImage: UIImage?
    var Level: Int
    
    init(profileImage: UIImage? = nil, level: Int) {
        self.ProfileImage = profileImage
        self.Level = level
    }
    
    var body: some View {
        // 프로필 이미지
        ZStack {
            VStack {
                //커스텀 이미지가 존재할 경우
                if (ProfileImage != nil) {
                    Image(uiImage: ProfileImage!)
                        .resizable()
                        .frame(width: 57, height: 57)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                } else {
                    //커스텀 이미지가 존재하지 않을 경우
                    Image("profile.circle")
                        .resizable()
                        .frame(width: 57, height: 57)
                }
                
                Spacer()
            }
            
            VStack {
                
                Spacer()
                
                Text("Lv. \(Level)")
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(Color.accent)
                    .padding(.horizontal, 14.5)
                    .padding(.vertical, 4)
                    .background(.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 0.5)
                            .stroke(.accent, lineWidth: 1)
                    )
            }
        }
        .frame(height: 68)
    }
}

#Preview {
    MyPageProfile()
}
