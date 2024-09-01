//
//  MoodViewModel.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI
import SwiftData

final class MoodViewModel: ObservableObject {
    @Published var feeling: String = "?"
    @Published var Fcolor: Color = .white
    @Published var selectedMood: ImageResource = .none
    @Published var scrollToBottom: Bool = false
    @Published var noteText: String = ""
    @Published var isNoteOpen: Bool = false
    @Published var showMoodView: Bool = false
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: Date()) {
        didSet {
            updateMoodEntries(allMoodEntries)
        }
    }
    @Published var greetingText: String = ""
    @Published var showingErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var allMoodEntries: [MoodEntry] = [] // 전체 MoodEntry 저장
    @Published var isLoading: Bool = false
    
    @Published private(set) var moods: [MoodModel] = [
        MoodModel(feeling: AppLocalized.feelingAngry, mood: .unhappy, color: .cUnhappy),
        MoodModel(feeling: AppLocalized.feelingSad, mood: .sad, color: .cSad),
        MoodModel(feeling: AppLocalized.feelingNomal, mood: .normal, color: .cNormal),
        MoodModel(feeling: AppLocalized.feelingGood, mood: .good, color: .cGood),
        MoodModel(feeling: AppLocalized.feelingHappy, mood: .happy, color: .cHappy)
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
        greetingText = AppLocalized.welcomeMessages.randomElement() ?? AppLocalized.welcomeMessages.first!
    }
    
    func deleteMood(entry: MoodEntry) {
        if let context = entry.modelContext {
            context.delete(entry)
            try? context.save()
            self.allMoodEntries.removeAll { $0.id == entry.id }
        }
    }
    
    func addMoodEntry(modelContext: ModelContext, moodImage: ImageResource, feeling: String, color: Color, note: String) {
        let newEntry = MoodEntry(moodImage: moodImage, feeling: feeling, color: color, note: note, date: Date())
        modelContext.insert(newEntry)
        
        do {
            try modelContext.save()
            
            self.allMoodEntries.append(newEntry)
        } catch {
            print("Failed to save MoodEntry: \(error.localizedDescription)")
            errorMessage = AppLocalized.errorAlertText
            showingErrorAlert = true
        }
    }
    
    func formattedDateHeader(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppLocalized.dateFormat
        return dateFormatter.string(from: date)
    }
    
    func formattedTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = AppLocalized.timeFormat
        return timeFormatter.string(from: date)
    }
    
    func changeMonth(to newMonth: Int) {
        isLoading = true
        selectedMonth = newMonth
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isLoading = false
        }
    }
    
    // 무드 엔트리 업데이트 메서드
    func updateMoodEntries(_ entries: [MoodEntry]) {
        self.allMoodEntries = entries
    }
    
    // 그룹화된 무드 엔트리 반환
    func groupedMoodEntries(_ entries: [MoodEntry]) -> [Date: [MoodEntry]] {
        Dictionary(grouping: entries.filter { entry in
            let month = Calendar.current.component(.month, from: entry.date)
            return month == selectedMonth
        }, by: { Calendar.current.startOfDay(for: $0.date) })
    }
}
