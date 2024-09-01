//
//  MoodEntryList.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct MoodEntryList: View {
    @ObservedObject var viewModel: MoodViewModel
    
    let groupedEntries: [Date: [MoodEntry]]
    let formattedDateHeader: (Date) -> String
    
    var body: some View {
        List {
            // ForEach에서 고유한 식별자를 정확히 설정
            ForEach(groupedEntries.keys.sorted(), id: \.self) { date in
                Section {
                    // 각 MoodEntry에 고유한 ID를 사용합니다.
                    ForEach(groupedEntries[date] ?? [], id: \.id) { entry in
                        MoodEntryRow(viewModel: viewModel, entry: entry)
                    }
                } header: {
                    Text(formattedDateHeader(date))
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
