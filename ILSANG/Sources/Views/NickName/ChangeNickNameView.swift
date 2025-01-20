//
//  ChangeNickNameView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import SwiftUI

struct ChangeNickNameView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var isSame : Bool = false
    @State private var isqualified : Bool = true
    @State private var showAlert : Bool = false
    
    //닉네임 최대치
    private let characterLimit = 12
    
    var body: some View {
        ZStack {
            VStack {
                NavigationTitleView(title: "정보 수정") {
                    if name.isEmpty {
                        dismiss()
                    } else {
                        showAlert.toggle()
                    }
                }
                
                VStack (alignment: .leading, spacing: 0) {
                    //설명
                    Text("새로운 닉네임을 입력하세요")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.gray500)
                        .padding(.bottom, 10)
                    
                    //닉네임 입력란
                    TextField("닉네임을 입력하세요", text: $name)
                        .font(.system(size: 16, weight: .bold))         
                        .foregroundColor(.gray500)
                        .frame(height: 22)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: 0.5)
                                .stroke(isSame ? Color.subRed : Color.clear, lineWidth: 2)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .background(Color.background)
                                .cornerRadius(12)
                        )
                        .padding(.bottom, 12)
                        .onChange(of: name) { _, maxName in
                            if maxName.count > characterLimit {
                                name = String(maxName.prefix(characterLimit))
                            }
                            isqualified = isValidNickname(maxName)
                        }
                    
                    ZStack(alignment: .leading) {
                        Text("한글+영어+숫자 포함 2 ~ 12자 이하로 닉네임을 입력해주세요.")
                            .opacity(isqualified ? 0 : 1)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.subRed)
                        
                        Text("입력하신 닉네임은 이미 사용중이에요.\n다른 닉네임을 입력해주세요.")
                            .opacity(isSame ? 1 : 0)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.subRed)
                    }
                    
                    Spacer()
                    
                    PrimaryButton(title: "변경 완료", buttonAble: !isSame && isqualified) {
                        Task {
                            if await UserNetwork().putUser(nickname: name) {
                                withAnimation {
                                    dismiss()
                                }
                            } else {
                                // TODO: 중복인 경우(400번 에러)랑 다른 에러랑 구분해서 보여주도록 수정
                                //중복되는 아이디가 있거나 서버 연결에 문제 있을 경우
                                isSame = true
                            }
                        }
                    }
                }
                .navigationBarBackButtonHidden()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(20)
            }
            if showAlert {
                SettingAlertView(alertType: .NickName,onCancel: {showAlert = false}, onConfirm: {dismiss()})
            }
        }
    }
    
    private func isValidNickname(_ name: String) -> Bool {
        let language = ".*[가-힣a-zA-Z0-9]+.*"
        let isMatche = NSPredicate(format: "SELF MATCHES %@", language).evaluate(with: name)
        let isValidLength = (2...12).contains(name.count)
        
        return isMatche && isValidLength
    }
}
