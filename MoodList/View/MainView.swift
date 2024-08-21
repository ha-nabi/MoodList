//
//  MainView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MoodViewModel()
    
    @Namespace private var animationNamespace
    
    @State private var moodEntries: [MoodEntry] = []
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var greetingText: String = ""

    let greetings = [
        "환영해요!\n오늘 당신의 무드를 여기 남겨보세요",
        "하루의 무드를 기록하는 순간,\n당신의 이야기를 들려주세요",
        "오늘의 무드는 어떤 색깔인가요?\n같이 기록해요",
        "하루의 끝,\n당신의 무드를 이야기해 주세요",
        "지금 이 순간의 무드는 어떤가요?\n함께 기록해 봐요",
        "당신의 이야기를 들려주세요.\n무드를 기록할 준비가 되었나요?",
        "오늘 하루,\n당신의 무드는 어떤 색깔인가요?",
        "하루를 마무리하며,\n오늘의 무드를 남겨보세요"
    ]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .gray]), startPoint: .bottomLeading, endPoint: .top)
                            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(greetingText)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .lineLimit(2)
                        .lineSpacing(6)
                        .foregroundStyle(.white)
                        .padding(20)
                    
                    Spacer()
                }

                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(1...12, id: \.self) { month in
                                Text("\(month)월")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 22)
                                    .background(
                                        RoundedRectangle(cornerRadius: 18)
                                            .fill(selectedMonth == month ? Color.cSad.opacity(0.9) : Color.gray.opacity(0.25))
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            selectedMonth = month
                                            proxy.scrollTo(month, anchor: .center)
                                        }
                                    }
                                    .foregroundColor(.white)
                                    .scaleEffect(selectedMonth == month ? 1.08 : 1.0)
                                    .animation(.spring(), value: selectedMonth)
                                    .id(month)
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        
                        Divider()
                    }
                    .background(Color.clear)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            proxy.scrollTo(selectedMonth, anchor: .center)
                        }
                    }
                }
                
                if filteredEntries.isEmpty {
                    VStack {
                        Spacer()
                        Text("등록된 무드가 없습니다.")
                            .foregroundStyle(.white)
                            .padding()
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(groupedEntries.keys.sorted(), id: \.self) { date in
                            Section(header: Text(formattedDateHeader(date))
                                        .foregroundStyle(.white)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                            ) {
                                ForEach(groupedEntries[date] ?? []) { entry in
                                    HStack(alignment: .top, spacing: 14) {
                                        Image(entry.moodImage)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .background(entry.color)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text("\(formattedTime(entry.date))의 무드는")
                                                    .font(.headline)
                                                    .foregroundStyle(.white)
                                                
                                                Text(entry.feeling)
                                                    .font(.headline)
                                                    .foregroundStyle(entry.color)
                                            }
                                            
                                            HStack {
                                                Text("\(entry.note) ")
                                                    .font(.body)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.25))
                                    .cornerRadius(10)
                                }
                                .onDelete(perform: deleteMood)
                            }
                            .listSectionSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .offset(y: -7)
                }
                Spacer()
            }
            .zIndex(0)
            .onAppear(perform: selectRandomGreeting)
            
            if viewModel.showMoodView {
                Color.black.ignoresSafeArea()
                    .zIndex(1)
                
                MoodView(viewModel: viewModel, animationNamespace: _animationNamespace) {
                    let newEntry = MoodEntry(
                        moodImage: viewModel.selectedMood,
                        feeling: viewModel.feeling,
                        color: viewModel.Fcolor,
                        note: viewModel.noteText,
                        date: Date()
                    )
                    moodEntries.append(newEntry)
                    viewModel.closeMoodView()
                }
                .zIndex(2)
                .transition(.scale(scale: 0.1, anchor: .bottomTrailing).combined(with: .opacity))
            } else {
                Button(action: {
                    viewModel.toggleMoodView()
                }) {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(.cSad.opacity(0.9).shadow(.drop(color: .white.opacity(0.25), radius: 5, x: 5, y: 5)), in: .circle)
                        .padding()
                }
                .zIndex(3)
            }
        }
    }
    
    // 랜덤으로 인사말 선택
    private func selectRandomGreeting() {
        greetingText = greetings.randomElement() ?? "환영합니다!"
    }
    
    // 선택된 월에 따라 필터링된 무드 리스트
    private var filteredEntries: [MoodEntry] {
        moodEntries.filter { entry in
            let month = Calendar.current.component(.month, from: entry.date)
            return month == selectedMonth
        }
    }
    
    // 날짜별로 그룹화된 무드 항목
    private var groupedEntries: [Date: [MoodEntry]] {
        groupEntriesByDate(entries: filteredEntries)
    }
    
    // 무드 항목을 날짜별로 그룹화하는 함수
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
    
    // 무드 삭제 함수
    private func deleteMood(at offsets: IndexSet) {
        moodEntries.remove(atOffsets: offsets)
    }
    
    // 날짜 포맷터 (월 일 형식)
    private func formattedDateHeader(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: date)
    }
    
    // 시간 포맷터 (시간:분 형식)
    private func formattedTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH시 mm분"
        return timeFormatter.string(from: date)
    }
}

#Preview {
    MainView()
}
