//
//  MoodView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct MoodView: View {
    @Namespace var animationNamespace
    @ObservedObject var viewModel: MoodViewModel
    var onMoodRegister: () -> Void
    
    var body: some View {
        ScrollViewReader { proxy in
            ZStack(alignment: .bottomTrailing) {
                Color.black.ignoresSafeArea()
                
                Circle().foregroundStyle(viewModel.Fcolor)
                    .frame(width: 300, height: 300)
                    .blur(radius: 200)
                    .offset(x: 130, y: 130)
                
                ScrollView {
                    VStack(spacing: 64) {
                        HStack(alignment: .firstTextBaseline) {
                            topTitle
                            
                            Spacer()
                            
                            Button {
                                viewModel.closeMoodView()
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                        }
                        
                        IconView(viewModel: viewModel)
                        
                        HStack(spacing: 20) {
                            ForEach(viewModel.moods) { mood in
                                VStack(spacing: 16) {
                                    Image(mood.mood)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                    
                                    Text(mood.feeling)
                                        .foregroundStyle(.white)
                                        .font(.body)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                }
                                .scaleEffect(viewModel.selectedMood == mood.mood ? 1.3 : 0.8)
                                .onTapGesture {
                                    viewModel.selectMood(mood: mood)
                                }
                            }
                        }
                        
                        NoteView(viewModel: viewModel, onRegister: {
                            onMoodRegister() // 무드 등록 로직 호출
                        })
                        .id("NoteView")
                    }
                    .padding()
                }
                .onChange(of: viewModel.scrollToBottom) { _, _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo("NoteView", anchor: .bottom)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
    
    var topTitle: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘 하루 당신의")
            
            HStack {
                Text("무드는")
                
                Text(viewModel.feeling)
                    .foregroundStyle(viewModel.Fcolor)
                    .contentTransition(.numericText())
            }
        }
        .foregroundStyle(.white)
        .font(.largeTitle.bold())
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
