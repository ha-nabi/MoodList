//
//  MainView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI
import SwiftData

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

                MonthPicker(
                    selectedMonth: $viewModel.selectedMonth,
                    animationNamespace: animationNamespace
                )
                .onChange(of: viewModel.selectedMonth) { newMonth, _ in
                    viewModel.changeMonth(to: newMonth)
                }

                Divider()

                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1)
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    let filteredEntries = viewModel.allMoodEntries.filter {
                        Calendar.current.component(.month, from: $0.date) == viewModel.selectedMonth
                    }

                    if filteredEntries.isEmpty {
                        VStack {
                            Spacer()
                            Text(AppLocalized.noMoodEntriesText)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .padding()
                            Spacer()
                        }
                    } else {
                        ScrollViewReader { proxy in
                            MoodEntryList(
                                viewModel: viewModel,
                                groupedEntries: viewModel.groupedMoodEntries(filteredEntries),
                                formattedDateHeader: viewModel.formattedDateHeader
                            )
                            .onAppear {
                                if let lastDate = viewModel.groupedMoodEntries(filteredEntries).keys.sorted().last {
                                    proxy.scrollTo(lastDate, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
            .zIndex(0)
            .onAppear {
                viewModel.selectRandomGreeting()
                viewModel.updateMoodEntries(moodEntries)
            }

            if viewModel.showMoodView {
                Color.black.ignoresSafeArea()
                    .zIndex(1)

                MoodView(
                    viewModel: viewModel,
                    animationNamespace: _animationNamespace
                ) {
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
