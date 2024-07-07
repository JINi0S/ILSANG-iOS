## 일상

### 💻 개발 기간

2024년 4월 ~ 개발 진행 중

</br>

### ✏️ 주요 기능 요약

- 퀘스트 탭에서는
    - 미완료한 퀘스트와 완료한 퀘스트의 목록을 조회할 수 있어요.
    - 미완료한 퀘스트는 이미지를 찍거나, 앨범에서 선택해 인증을 할 수 있어요.
- 인증 탭에서는
    - 다른 사용자들의 인증 내역 사진을 조회할 수 있어요.
    - 인증 사진에는 좋아요, 싫어요 이모지를 남길 수 있어요.
- 마이 탭에서는
    - 닉네임을 수정할 수 있어요.
    - 수행했던 퀘스트를 보거나, 이모지를 남겼던 활동 내역을 볼 수 있어요.
</br>


</br>

### 🖼️ 주요 화면

| 퀘스트 탭 | 인증 탭 | 마이 탭 |
| --- | --- | --- |
| <img src = "https://github.com/JINi0S/ILSANG-iOS/assets/100195563/9d25f661-7854-4b3d-adfd-d4bf3900da47" width = "280"> | <img src = "https://github.com/JINi0S/ILSANG-iOS/assets/100195563/c7732f77-22df-49b7-80f9-372ec4291092" width = "280"> | <img src = "https://github.com/JINi0S/ILSANG-iOS/assets/100195563/c5253fb2-3572-4a7f-b1aa-aff46dfa7918" width = "280"> |

</br>

### 🔥 기여 기능

[작업했던 PR](https://github.com/TeamFair/ILSANG-iOS/pulls?q=is%3Apr+is%3Aclosed+author%3AJINi0S)

- [네트워크 클래스 생성](https://github.com/TeamFair/ILSANG-iOS/blob/develop/ILSANG/Sources/Network/Base/Network.swift)
    - 싱글톤 패턴, 빌더 패턴의 디자인 패턴 활용
    - 데이터 조회, 이미지 데이터 조회, 이미지 데이터 등록 메서드 구현
- 인증 탭
    - 도전내역, 이미지를 불러오는 기능 구현
    - 도전내역에 대한 이모지 조회, 등록, 삭제 기능 구현
    - 드래그 시 도전내역을 하나씩 볼 수 있도록 애니메이션 및 UI 구현
- 퀘스트 탭
    - 다양한 엣지케이스를 가진 퀘스트 리스트 UI 구현
    - 퀘스트 선택 후 이미지로 인증하는 플로우 구현
        - [도전내역 등록](https://github.com/TeamFair/ILSANG-iOS/pull/70) 기능 구현
            - [카메라로 직접 촬영](https://github.com/TeamFair/ILSANG-iOS/pull/23)하여 도전내역을 서버에 등록
            - 앨범에서 이미지를 선택하여 도전내역을 서버에 등록
        - [이미지 서버 업로드 기능 구현](https://github.com/TeamFair/ILSANG-iOS/pull/58)
            - 30초 타임아웃 및 3회 재시도, 실패시 1초 후 재시도
            - 이미지 사이즈 width, height 중 하나라도 3000이상이면, 이미지 다운샘플링 후 업로드

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

<img src = "https://github.com/JINi0S/ILSANG-iOS/assets/100195563/29d67c98-63da-4db8-8986-9748fb9941e8" width = "720">


