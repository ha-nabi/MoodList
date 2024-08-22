//
//  MoodActionButton.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct MoodActionButton: View {
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "plus")
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 55, height: 55)
                .background(.cSad.opacity(0.9).shadow(.drop(color: .white.opacity(0.25), radius: 5, x: 5, y: 5)), in: .circle)
                .padding()
        }
    }
}
