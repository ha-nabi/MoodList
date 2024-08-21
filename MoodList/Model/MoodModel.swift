//
//  MoodModel.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import SwiftUI

struct MoodModel: Identifiable {
    var id = UUID()
    var feeling: String
    var mood: ImageResource
    var color: Color
}
