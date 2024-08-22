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

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                gradient: Gradient(colors: [.black, .black, .black, .gray]),
                startPoint: .bottomLeading,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(viewModel.greetingText)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .lineLimit(2)
                        .lineSpacing(8)
                        .foregroundStyle(.white)
                        .padding(20)
                    
                    Spacer()
                }

                MonthPicker(selectedMonth: $viewModel.selectedMonth, animationNamespace: animationNamespace)

                Divider()
                    .offset(y: 7)
                
                if viewModel.filteredEntries.isEmpty {
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
                    MoodEntryList(groupedEntries: viewModel.groupedEntries, formattedDateHeader: viewModel.formattedDateHeader, viewModel: viewModel)
                }
            }
            .zIndex(0)
            .onAppear(perform: viewModel.selectRandomGreeting)
            
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
                    viewModel.moodEntries.append(newEntry)
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
}

#Preview {
    ContentView()
}
