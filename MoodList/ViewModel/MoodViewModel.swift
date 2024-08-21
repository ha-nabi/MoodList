//
//  MoodViewModel.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var feeling: String = "?"
    @Published var Fcolor: Color = .white
    @Published var selectedMood: ImageResource = .none
    @Published var scrollToBottom: Bool = false
    @Published var noteText: String = ""
    @Published var isNoteOpen: Bool = false
    @Published var showMoodView: Bool = false

    let moods: [MoodModel] = [
        MoodModel(feeling: "화나요", mood: .unhappy, color: .cUnhappy),
        MoodModel(feeling: "우울해요", mood: .sad, color: .cSad),
        MoodModel(feeling: "그저 그래요", mood: .normal, color: .cNormal),
        MoodModel(feeling: "좋아요", mood: .good, color: .cGoog),
        MoodModel(feeling: "행복해요", mood: .happy, color: .cHappy)
    ]
    
    func selectMood(mood: MoodModel) {
        withAnimation {
            self.selectedMood = mood.mood
            self.Fcolor = mood.color
            self.feeling = mood.feeling
        }
    }
    
    func reset() {
        self.selectedMood = .none
        self.feeling = "?"
        self.Fcolor = .white
        self.noteText = ""
        self.isNoteOpen = false
        self.scrollToBottom = false
    }
    
    func getTextColor() -> Color {
        switch selectedMood {
        case .unhappy, .sad, .normal:
            return .white
        case .none, .good, .happy:
            return .black
        default:
            return .white
        }
    }
    
    func toggleNoteOpen() {
        withAnimation {
            isNoteOpen.toggle()
            scrollToBottom.toggle()
        }
    }
    
    func toggleMoodView() {
        HapticFeedbackManager.shared.triggerHapticFeedback()
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
            showMoodView.toggle()
            
            if showMoodView {
                reset()
            }
        }
    }
    
    func closeMoodView() {
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
            showMoodView = false
        }
    }
}
