//
//  MoodEntryList.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct MoodEntryList: View {
    let groupedEntries: [Date: [MoodEntry]]
    let formattedDateHeader: (Date) -> String
    let viewModel: MoodViewModel

    var body: some View {
        List {
            ForEach(groupedEntries.keys.sorted(), id: \.self) { date in
                Section {
                    ForEach(groupedEntries[date] ?? []) { entry in
                        MoodEntryRow(entry: entry, viewModel: viewModel)
                    }
                } header: {
                    Text(formattedDateHeader(date))
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    
                }
                .listRowBackground(Color.clear)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
