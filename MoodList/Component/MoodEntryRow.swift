//
//  MoodEntryRow.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct MoodEntryRow: View {
    @ObservedObject var viewModel: MoodViewModel
    
    let entry: MoodEntry

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Image(entry.moodImage)
                .resizable()
                .frame(width: 50, height: 50)
                .background(entry.color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(viewModel.formattedTime(entry.date))의 무드는")
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
            .padding()
            .background(
                TransparentBlur(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background(Color.gray.opacity(0.15))
            )
            .cornerRadius(10)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            
            Spacer()
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.deleteMood(entry: entry)
            } label: {
                Text("삭제")
            }
        }
    }
}
