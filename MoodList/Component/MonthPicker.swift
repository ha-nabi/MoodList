//
//  MonthPicker.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct MonthPicker: View {
    @Binding var selectedMonth: Int
    
    let animationNamespace: Namespace.ID

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(1...12, id: \.self) { month in
                        Text("\(month)월")
                            .font(.body)
                            .fontWeight(.medium)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 22)
                            .background {
                                ZStack {
                                    TransparentBlur(removeAllFilters: true)
                                        .blur(radius: 9, opaque: true)
                                        .background(Color.gray.opacity(0.15))
                                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    
                                    if selectedMonth == month {
                                        TransparentBlur(removeAllFilters: false)
                                            .background(Color.cSad.opacity(0.9))
                                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                                    }
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 0.4)
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedMonth = month
                                    proxy.scrollTo(month, anchor: .center)
                                }
                            }
                            .foregroundColor(.white)
                            .scaleEffect(selectedMonth == month ? 1.08 : 1.0)
                            .animation(.spring(), value: selectedMonth)
                            .id(month)
                    }
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            .background(Color.clear)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    proxy.scrollTo(selectedMonth, anchor: .center)
                }
            }
        }
    }
}

#Preview {
    @State var selectedMonth = 1
    @Namespace var animationNamespace
    return MonthPicker(selectedMonth: $selectedMonth, animationNamespace: animationNamespace)
}
