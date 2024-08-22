//
//  MoodViewModel.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

final class MoodViewModel: ObservableObject {
    @Published var feeling: String = "?"
    @Published var Fcolor: Color = .white
    @Published var selectedMood: ImageResource = .none
    @Published var scrollToBottom: Bool = false
    @Published var noteText: String = ""
    @Published var isNoteOpen: Bool = false
    @Published var showMoodView: Bool = false
    @Published var moodEntries: [MoodEntry] = []
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var greetingText: String = ""

    let moods: [MoodModel] = [
        MoodModel(feeling: "화나요", mood: .unhappy, color: .cUnhappy),
        MoodModel(feeling: "우울해요", mood: .sad, color: .cSad),
        MoodModel(feeling: "그저 그래요", mood: .normal, color: .cNormal),
        MoodModel(feeling: "좋아요", mood: .good, color: .cGoog),
        MoodModel(feeling: "행복해요", mood: .happy, color: .cHappy)
    ]
    
    private let greetings = [
        "환영해요!\n오늘 당신의 무드를 여기 남겨보세요",
        "하루의 무드를 기록하는 순간,\n당신의 이야기를 들려주세요",
        "오늘의 무드는 어떤 색깔인가요?\n같이 기록해요",
        "하루의 끝,\n당신의 무드를 이야기해 주세요",
        "지금 이 순간의 무드는 어떤가요?\n함께 기록해 봐요",
        "당신의 이야기를 들려주세요.\n무드를 기록할 준비가 되었나요?",
        "오늘 하루,\n당신의 무드는 어떤 색인가요?",
        "하루를 마무리하며,\n오늘의 무드를 남겨보세요"
    ]
    
    init() {
        selectRandomGreeting()
    }
    
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

    func selectRandomGreeting() {
        greetingText = greetings.randomElement() ?? "환영합니다!"
    }
    
    var filteredEntries: [MoodEntry] {
        moodEntries.filter { entry in
            let month = Calendar.current.component(.month, from: entry.date)
            return month == selectedMonth
        }
    }

    var groupedEntries: [Date: [MoodEntry]] {
        groupEntriesByDate(entries: filteredEntries)
    }

    private func groupEntriesByDate(entries: [MoodEntry]) -> [Date: [MoodEntry]] {
        var grouped = [Date: [MoodEntry]]()
        for entry in entries {
            let date = Calendar.current.startOfDay(for: entry.date)
            if grouped[date] == nil {
                grouped[date] = []
            }
            grouped[date]?.append(entry)
        }
        return grouped
    }

    func deleteMood(at offsets: IndexSet) {
        moodEntries.remove(atOffsets: offsets)
    }

    func deleteMood(entry: MoodEntry) {
        if let index = moodEntries.firstIndex(where: { $0.id == entry.id }) {
            moodEntries.remove(at: index)
        }
    }

    func formattedDateHeader(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: date)
    }

    func formattedTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH시 mm분"
        return timeFormatter.string(from: date)
    }
}
