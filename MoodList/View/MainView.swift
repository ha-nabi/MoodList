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
    
    @Query private var moodEntries: [MoodEntry]

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                gradient: Gradient(colors: [.black, .black, .black, .gray]),
                startPoint: .bottomLeading,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text(viewModel.greetingText)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .lineLimit(2)
                        .lineSpacing(8)
                        .foregroundStyle(.white)
                        .padding()
                    
                    Spacer()
                }

                MonthPicker(selectedMonth: $viewModel.selectedMonth, animationNamespace: animationNamespace)

                Divider()
                
                if filteredEntries.isEmpty {
                    VStack {
                        Spacer()
                        Text("등록된 무드가 없습니다.")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding()
                        Spacer()
                    }
                } else {
                    MoodEntryList(viewModel: viewModel, groupedEntries: groupedEntries, formattedDateHeader: viewModel.formattedDateHeader)
                }
            }
            .zIndex(0)
            .onAppear(perform: viewModel.selectRandomGreeting)
            
            if viewModel.showMoodView {
                Color.black.ignoresSafeArea()
                    .zIndex(1)
                
                MoodView(viewModel: viewModel, animationNamespace: _animationNamespace) {
                    viewModel.closeMoodView()
                }
                .zIndex(2)
                .transition(.scale(scale: 0.1, anchor: .bottomTrailing).combined(with: .opacity))
            } else {
                MoodActionButton {
                    viewModel.toggleMoodView()
                }
                .zIndex(3)
            }
        }
    }
    
    var filteredEntries: [MoodEntry] {
        moodEntries.filter { entry in
            let month = Calendar.current.component(.month, from: entry.date)
            return month == viewModel.selectedMonth
        }
    }

    var groupedEntries: [Date: [MoodEntry]] {
        Dictionary(grouping: filteredEntries, by: { Calendar.current.startOfDay(for: $0.date) })
    }
}
