//
//  NoteView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var viewModel: MoodViewModel
    @FocusState private var isFocused: Bool
    var onRegister: () -> Void
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    viewModel.toggleNoteOpen()
                    isFocused = true  // 버튼을 누르면 자동으로 TextField에 포커스
                }
            } label: {
                Text("무드를 작성하세요")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(viewModel.isNoteOpen ? [.top, .leading] : .all)
                    .frame(maxWidth: .infinity, alignment: viewModel.isNoteOpen ? .topLeading : .center)
            }
            
            if viewModel.isNoteOpen {
                TextField("오늘 당신의 무드는 어땠나요?", text: $viewModel.noteText)
                    .padding(10)
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .background(.gray.opacity(0.3), in: .rect(cornerRadius: 8))
                    .padding()
                    .tint(viewModel.Fcolor)
                    .focused($isFocused)
                
                Button {
                    onRegister() // 등록 버튼 클릭 시 무드 저장 로직 호출
                } label: {
                    Text("등록")
                        .foregroundStyle(viewModel.getTextColor())
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(viewModel.Fcolor)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
        .overlay(alignment: .topTrailing) {
            if viewModel.isNoteOpen {
                Button {
                    // 키보드가 내려간 후에 버튼이 줄어들도록 순서 조정
                    isFocused = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            viewModel.isNoteOpen = false
                        }
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .padding()
                }
                .tint(.white)
            }
        }
        .frame(height: viewModel.isNoteOpen ? 200 : 55)
        .frame(maxWidth: .infinity)
        .background(.gray.opacity(0.3), in: .rect(cornerRadius: 12))
        .clipped()
        .onAppear {
            if viewModel.isNoteOpen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
        }
    }
}
