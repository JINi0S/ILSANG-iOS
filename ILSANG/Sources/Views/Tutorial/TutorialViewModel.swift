//
//  TutorialViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 1/5/25.
//

import UIKit

struct TutorialContent {
    let id: Int
    let title: String
    let image: UIImage
}

final class TutorialViewModel: ObservableObject {
    @Published var step: Int = 0
    @Published var finish: Bool = false
    
    var isFirst: Bool {
        step == 0
    }
    
    var isLast: Bool {
        step == content.count-1
    }
    
    let content: [TutorialContent]
    var currentContent: TutorialContent {
        content[step]
    }
    let contentCount: Int
    
    init(content: [TutorialContent]) {
        self.content = content
        self.contentCount = content.count
    }
    
    func performPrimaryAction() {
        if isLast {
            finish = true
        } else {
            step += 1
        }
    }
    
    func performSecondaryAction() {
        guard step > 0 else { return }
        step -= 1
    }
}
