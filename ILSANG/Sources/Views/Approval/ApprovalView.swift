//
//  ApprovalView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

import SwiftUI

struct ApprovalView: View {
    @StateObject var vm = ApprovalViewModel()
        
    private let viewWidth = UIScreen.main.bounds.width - 40
    private let viewHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 0) {
            itemView
            recommendButtons
        }
        .padding(.horizontal, 20)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(vm.itemList[vm.idx].image)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .scaledToFill()
                .scaleEffect(1.4)
                .blur(radius: 30, opaque: true)
                .background(Color.black.opacity(0.2))
        )
        .task {
            await vm.getEmoji(challengeId: "CH00000100")
        }
    }
    
    /// 퀘스트 타이틀  + 퀘스트 인증 이미지
    private var itemView: some View {
        VStack(spacing: 14) {
            Text(vm.itemList[vm.idx].title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.gray400)
                .frame(height: 45)
                .frame(width: viewWidth - 20, alignment: .leading)
                .padding(.leading, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.white)
                )
                .zIndex(1)
            
            ZStack(alignment: .bottom) {
                ForEach(vm.itemList.reversed(), id: \.id) { story in
                    let diff: Int = abs(story.id - vm.idx)
                    ApprovalImageView(
                        image: story.image,
                        width: abs(viewWidth - 40 * CGFloat(diff)),
                        height: (viewHeight / 2) - CGFloat(diff) * 26,
                        nickname:story.nickname,
                        time: story.time,
                        showProfile: diff <= 1
                    )
                    .opacity(vm.calculateOpacity(id: story.id))
                    .offset(y: diff <= 2 ? CGFloat(diff) * 26 : 50)
                    .offset(y: story.offset)
                }
                .gesture(dragGesture)
            }
            .mask(alignment: .top) {
                maskArea
            }
        }
        .shadow(color: .shadowFF.opacity(0.25), radius: 20, x: 0, y: 12)
    }
    
    /// 이미지 스크롤 시 상단 마스크
    private var maskArea: some View {
        VStack(spacing: 0) {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .clear, location: .zero),
                    Gradient.Stop(color: .black, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 16)
            Color.black
        }
        .padding(.top, -20)
        .padding(.bottom, -60)
    }
    
    private var recommendButtons: some View {
        HStack(spacing: 78) {
            Button {
                vm.tappedRecommendBtn(recommend: false)
            } label: {
                Image(.unlike)
            }
            Button {
                vm.tappedRecommendBtn(recommend: true)
            } label: {
                Image(.like)
            }
        }
        .padding(.top, 72)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    vm.handleDragChange(value)
                }
            }
            .onEnded { value in
                withAnimation {
                    vm.handleDragEnd(value, viewHeight)
                }
            }
    }
}

#Preview {
    ApprovalView()
}
