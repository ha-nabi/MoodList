//
//  ContentView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct MoodEntry: Identifiable {
    let id = UUID()
    let moodImage: ImageResource
    let feeling: String
    let color: Color
    let note: String
    let date: Date
}

struct ContentView: View {
    @StateObject private var viewModel = MoodViewModel()
    @Namespace private var animationNamespace
    @State private var moodEntries: [MoodEntry] = []
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.black.ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("오늘의 무드 기록")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                }
                
                if moodEntries.isEmpty {
                    VStack {
                        
                        Spacer()
                        
                        Text("등록된 무드가 없습니다.")
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(moodEntries) { entry in
                            HStack {
                                Image(entry.moodImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .background(entry.color)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(formattedDate(entry.date))의 무드는")
                                            .font(.headline)
                                            .foregroundColor(.white) // 날짜와 "무드는" 텍스트는 흰색
                                        
                                        Text(entry.feeling)
                                            .font(.headline)
                                            .foregroundColor(entry.color) // 무드 텍스트는 지정된 색상
                                    }
                                    Text(entry.note)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                        .onDelete(perform: deleteMood)
                    }
                    .listStyle(PlainListStyle())
                }
                Spacer()
            }
            .zIndex(0)
            
            if viewModel.showMoodView {
                Color.black.opacity(0.5).ignoresSafeArea() // 배경을 반투명하게 하여 MoodView 강조
                    .zIndex(1)
                
                MoodView(animationNamespace: _animationNamespace, viewModel: viewModel) {
                    // 무드 등록 로직
                    let newEntry = MoodEntry(
                        moodImage: viewModel.selectedMood,
                        feeling: viewModel.feeling,
                        color: viewModel.Fcolor,
                        note: viewModel.noteText,
                        date: Date() // 현재 날짜를 저장
                    )
                    moodEntries.append(newEntry)
                    viewModel.closeMoodView()
                }
                .zIndex(2)
                .transition(.scale.combined(with: .opacity))
            } else {
                Button(action: {
                    viewModel.toggleMoodView()
                }) {
                    Circle()
                        .foregroundStyle(Color.gray)
                        .frame(width: 50, height: 50)
                        .matchedGeometryEffect(id: "circle", in: animationNamespace)
                        .padding()
                }
                .zIndex(3) // 버튼은 가장 위에
            }
        }
    }
    
    // 무드 삭제 함수
    private func deleteMood(at offsets: IndexSet) {
        moodEntries.remove(atOffsets: offsets)
    }
    
    // 날짜 포맷터 (월 일 형식)
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
