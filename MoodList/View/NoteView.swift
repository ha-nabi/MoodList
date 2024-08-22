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
                withAnimation {
                    viewModel.toggleNoteOpen()
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
                    .background(TransparentBlur(removeAllFilters: true)
                                    .blur(radius: 20, opaque: true)
                                    .background(Color.gray.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 8)))
                    .padding()
                    .tint(viewModel.Fcolor)
                    .onTapGesture {
                        withAnimation {
                            viewModel.scrollToBottom = true
                        }
                    }
                
                Button {
                    onRegister()
                } label: {
                    Text("등록")
                        .foregroundStyle(viewModel.noteText.isEmpty ? Color(.gray) : viewModel.getTextColor())
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(viewModel.noteText.isEmpty ? Color(.darkGray) : viewModel.Fcolor)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .disabled(viewModel.noteText.isEmpty)
            }
        }
        .overlay(alignment: .topTrailing) {
            if viewModel.isNoteOpen {
                Button {
                    withAnimation {
                        viewModel.isNoteOpen = false
                        viewModel.noteText = ""
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
        .background(
            TransparentBlur(removeAllFilters: true)
                .blur(radius: 50, opaque: true)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        )
        .clipped()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1.4)
        }
    }
}
