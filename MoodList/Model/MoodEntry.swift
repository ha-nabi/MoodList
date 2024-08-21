//
//  MoodEntry.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
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
