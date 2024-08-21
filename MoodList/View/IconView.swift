//
//  IconView.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct IconView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    @State private var scale = false
    @State private var FaceScale: CGFloat = 1
    
    var body: some View {
        ZStack {
            Circle().frame(width: 220, height: 220)
                .foregroundStyle(viewModel.Fcolor)
                .opacity(scale ? 0 : 1)
                .scaleEffect(scale ? 1 : 0.4)
            
            Circle().frame(width: 300, height: 300)
                .foregroundStyle(viewModel.Fcolor)
                .opacity(scale ? 0 : 1)
                .scaleEffect(scale ? 1 : 0.2)
            
            Image(viewModel.selectedMood)
                .resizable().scaledToFill()
                .frame(width: 150, height: 150)
                .scaleEffect(FaceScale)
        }
        .onChange(of: viewModel.selectedMood) { _, _ in
            withAnimation {
                FaceScale = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    FaceScale = 1
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                scale.toggle()
            }
        }
    }
}
