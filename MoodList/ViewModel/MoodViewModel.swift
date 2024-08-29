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
    //MARK: 무드필터링 관련
    @Published var filteredMoodEntries: [MoodEntry] = [] // 필터링된 MoodEntry 저장
    @Published var allMoodEntries: [MoodEntry] = [] // 전체 MoodEntry 저장
    @Published var selectedMoodFilter: ImageResource? = nil // 필터링할 무드
    
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
            applyMoodFilter()
        }
    }
    
    func addMoodEntry(modelContext: ModelContext, moodImage: ImageResource, feeling: String, color: Color, note: String) {
        let newEntry = MoodEntry(moodImage: moodImage, feeling: feeling, color: color, note: note, date: Date())
        modelContext.insert(newEntry)
        
        do {
            try modelContext.save()
            
            self.allMoodEntries.append(newEntry)
            applyMoodFilter()
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
    
    // MARK: - 무드 필터링 관련
    // 무드 엔트리 업데이트 메서드
    func updateMoodEntries(_ entries: [MoodEntry]) {
        self.allMoodEntries = entries
        applyMoodFilter()
    }
    
    // 특정 무드에 따른 필터링 적용
    func filterByMood(mood: ImageResource) {
        if selectedMoodFilter == mood {
            resetMoodFilter() // 이미 선택된 무드를 다시 클릭하면 필터 리셋
        } else {
            self.selectedMoodFilter = mood
            applyMoodFilter()
        }
    }
    
    // 무드 필터 리셋
    func resetMoodFilter() {
        self.selectedMoodFilter = nil
        applyMoodFilter()
    }
    
    // 필터된 무드 엔트리를 업데이트
    private func applyMoodFilter() {
        // 현재 선택된 달과 무드에 맞는 엔트리만 필터링
        filteredMoodEntries = allMoodEntries.filter { entry in
            let month = Calendar.current.component(.month, from: entry.date)
            let matchesMonth = month == selectedMonth
            
            if let moodFilter = selectedMoodFilter {
                return matchesMonth && entry.moodImage == moodFilter.rawValue
            } else {
                return matchesMonth
            }
        }
    }
    
    // 그룹화된 무드 엔트리 반환
    func groupedMoodEntries(_ entries: [MoodEntry]) -> [Date: [MoodEntry]] {
        Dictionary(grouping: entries, by: { Calendar.current.startOfDay(for: $0.date) })
    }
}

extension MoodViewModel {
    func filteredEntries(_ entries: [MoodEntry]) -> [MoodEntry] {
        entries.filter { entry in
            let month = Calendar.current.component(.month, from: entry.date)
            return month == selectedMonth
        }
    }
    
    func groupedEntries(_ entries: [MoodEntry]) -> [Date: [MoodEntry]] {
        Dictionary(grouping: filteredEntries(entries), by: { Calendar.current.startOfDay(for: $0.date) })
    }
}
