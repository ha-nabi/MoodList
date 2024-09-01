//
//  MoodFilterView.swift
//  MoodList
//
//  Created by 강치우 on 8/29/24.
//

import SwiftUI

struct MoodFilterView: View {
    @ObservedObject var viewModel: MoodViewModel
    let moodEntries: [MoodEntry]

    var body: some View {
        HStack(spacing: 26) {
            ForEach(viewModel.moods, id: \.id) { mood in
                let count = moodEntries.filter { $0.moodImage == mood.mood.rawValue }.count
                HStack(spacing: 8) {
                    Button {
                        if viewModel.selectedMoodFilter == mood.mood {
                            viewModel.resetMoodFilter() // 이미 선택된 무드를 다시 클릭하면 리셋
                        } else {
                            viewModel.filterByMood(mood: mood.mood) // 새로운 무드를 선택하면 필터 적용
                        }
                    } label: {
                        Image(mood.mood.rawValue)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 25, height: 25)
                    }
                    
                    Text("\(count)")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            }
        }
        .padding()
    }
}
