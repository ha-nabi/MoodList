//
//  NoteView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct NoteView: View {
    @ObservedObject var viewModel: MoodViewModel
    var onRegister: () -> Void
    
    var body: some View {
        VStack {
            Button {
                viewModel.toggleNoteOpen()
            } label: {
                Text("무드를 작성하세요")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding()
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
                
                Button {
                    onRegister() // 등록 버튼 클릭 시 무드 저장 로직 호출
                } label: {
                    Text("등록")
                        .foregroundStyle(viewModel.getTextColor())
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(viewModel.Fcolor)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
        .overlay(alignment: .topTrailing) {
            if viewModel.isNoteOpen {
                Button {
                    withAnimation {
                        viewModel.isNoteOpen = false
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
    }
}
