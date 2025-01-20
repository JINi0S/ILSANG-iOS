## 일상

### 💻 개발 기간

2024년 4월 ~ 진행 중

</br>

### ✏️ 주요 기능 요약

- 홈 탭에서는
    - 배너, 인기 퀘스트와 추천 퀘스트, 큰 보상 퀘스트, 랭킹 목록을 살펴볼 수 있어요.
- 퀘스트 탭에서는
    - 미완료한 기본 퀘스트와 반복 퀘스트, 완료한 퀘스트의 목록을 확인할 수 있어요.
    - 미완료한 퀘스트는 이미지를 찍거나, 앨범에서 선택해 인증을 할 수 있어요.
- 인증 탭에서는
    - 다른 사용자들의 인증 내역 사진을 조회할 수 있어요.
    - 인증 사진에는 좋아요, 싫어요 이모지를 남길 수 있어요.
    - 다른 사용자들의 부적절한 사진은 신고할 수 있어요.
- 랭킹 탭에서는
    - 사용자들의 XP별 랭킹을 확인할 수 있어요.
- 마이 탭에서는
    - 닉네임을 수정할 수 있어요.
    - 수행했던 도전내역을 보거나, 이모지를 남겼던 활동 내역을 볼 수 있어요.
    - 수행했던 도전내역을 이미지로 공유할 수 있어요.
      
</br>


</br>

### 🖼️ 주요 화면

| 로그인 | 튜토리얼 | 홈 탭 | 
| --- | --- | --- |
| ![Simulator Screen Recording - iPhone 15 - 2025-01-20 at 18 24 25](https://github.com/user-attachments/assets/64f78691-0f19-448b-97ba-3af6f45a0afc) | ![튜토리얼](https://github.com/user-attachments/assets/4cdb9b0c-5b9b-40c2-8193-636161d2ce54) | ![홈탭(랭킹없는 버전)](https://github.com/user-attachments/assets/9d7f044f-67f3-4407-961c-d56f6fccfe57) |


| 퀘스트 탭(도전내역 제출) | 인증 탭 | 랭킹 탭 | 마이 탭 |
| --- | --- | --- | --- | 
| ![퀘스트 인증(도전내역 제출)](https://github.com/user-attachments/assets/2c3e892e-ef0e-4a41-a10b-11c6d3c1ae11) | ![인증탭](https://github.com/user-attachments/assets/9eb87bae-8826-43e0-8d7a-2e42a7424624) | ![랭킹탭](https://github.com/user-attachments/assets/9abe6a9d-502c-41cc-8082-723eced077c3) | ![마이탭](https://github.com/user-attachments/assets/f6cebd02-e33d-4a14-8c9a-53de2c489321) |

</br>

### 🔥 기여 기능

[작업했던 PR](https://github.com/TeamFair/ILSANG-iOS/pulls?q=is%3Apr+is%3Aclosed+author%3AJINi0S)

- [네트워크 클래스 생성](https://github.com/TeamFair/ILSANG-iOS/blob/develop/ILSANG/Sources/Network/Base/Network.swift)
  - 빌더 패턴을 활용하여 네트워크 클래스 설계
	- 데이터 조회, 이미지 데이터 조회 및 등록 메서드 구현으로 다양한 API 호출 지원
- 이미지 캐시
	- 네트워크 비용 절감을 위한 메모리 기반 이미지 캐싱 로직 구현
	- 중복되는 이미지 데이터에 대해 캐싱을 적용하여 앱 성능 개선
- 로그인 및 튜토리얼
	- TabView를 활용한 로그인 컨텐츠 자동 스크롤 기능 구현
	- TabView를 활용한 튜토리얼 기능 구현
- 홈 탭
  	- 홈 화면 UI 전반을 구현하며, TabView를 활용해 인기 퀘스트에 대한 페이징 처리 기능 추가
	  - 추천, 인기, 큰 보상 퀘스트 목록 데이터를 API 조회하는 기능 구현
	  -	데이터 로드 시 비동기 작업을 병렬로 처리하여 로딩 속도 최적화
- 퀘스트 탭
    - 다양한 엣지 케이스를 처리할 수 있는 퀘스트 목록 UI 설계 및 구현
    - 퀘스트 선택 후 사용자 이미지를 활용한 인증 플로우 구축
        - [도전내역 등록](https://github.com/TeamFair/ILSANG-iOS/pull/70) 기능 구현
            - [카메라 촬영](https://github.com/TeamFair/ILSANG-iOS/pull/23) 및 앨범 이미지를 활용한 도전내역 서버 업로드 기능 구현
        - [이미지 서버 업로드 기능 구현](https://github.com/TeamFair/ILSANG-iOS/pull/58)
            - 30초 타임아웃 및 3회 재시도 로직 적용
			- 업로드 전 이미지 크기(가로, 세로 중 3000 이상) 다운샘플링 처리로 서버 안정성 확보
- 인증 탭
    - 도전내역 및 이미지를 불러오는 기능 구현
    - 도전내역에 대한 이모지 조회, 등록, 삭제 기능 구현
    - 드래그 시 도전내역을 하나씩 볼 수 있도록 애니메이션 및 UI 구현
 

</br>

### 🏛️ Architecture ∙ Framework ∙ Library
    
| Category | Name | Tag |
| --- | --- | --- |
| Architecture | MVVM |  |
| Framework | SwiftUI | UI |
|  | AVFoundation | Camera |
|  | PhotosUI | Photo Library |
| Library | Alamofire | Network |
| ETC | Swift Concurrency |  |

</br>

### 💁🏻‍♀️ IA

<img width="1927" alt="Frame 1707481586" src="https://github.com/user-attachments/assets/5f58b5f0-a105-459c-ba46-064e7a19536a" />


