//
//  CameraView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/29/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject var viewModel = CameraViewModel()
    @ObservedObject var submitViewModel: SubmitRouterViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        viewModel.cameraPreview
            .overlay(alignment: .bottom) {
                bottomView
            }
            .overlay(alignment: .topLeading) {
                Button {
                    dismiss()
                } label: {
                    DismissButton()
                        .padding()
                }
            }
            .ignoresSafeArea()
            .opacity(viewModel.shutterEffect ? 0 : 1)
            .task {
                viewModel.configure()
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { val in
                        viewModel.zoom(factor: val)
                    }
                    .onEnded { _ in
                        viewModel.zoomInitialize()
                    }
            )
            .alert(Text("현재 카메라 사용에 대한 접근 권한이 없습니다."), isPresented: $viewModel.showPermissionErrorAlert, actions: {
                Button("설정", role: .none) {
                    guard let settingURL = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(settingURL)
                    else { return }
                    UIApplication.shared.open(settingURL, options: [:])
                }
                Button("취소", role: .cancel) {
                    viewModel.showPermissionErrorAlert.toggle()
                }
            }, message: { Text("설정 > \"일상\"에서 접근을 활성화 할 수 있습니다")})
    }
    
    private var bottomView: some View {
        HStack {
            /// 이미지 프리뷰 - 앨범 선택
            ImagePreviewButton(submitViewModel: submitViewModel)
             
            Spacer()
            
            /// 사진찍기 버튼
            Button {
                viewModel.capturePhoto()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let myImage = viewModel.recentImage {
                        self.submitViewModel.selectedImage = myImage
                    }
                }
            } label: {
                Circle()
                    .stroke(lineWidth: 5)
                    .frame(width: 75, height: 75)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            /// 양쪽 비율 맞춰주기 위한 Spacer
            Spacer().frame(width: 50, height: 50)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 75)
    }
}


struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        view.videoPreviewLayer.session = session
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
}

#Preview {
    CameraView(submitViewModel: SubmitRouterViewModel(selectedQuestId: ""))
}
