//
//  MoodEntry.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI
import SwiftData

@Model
class MoodEntry: Identifiable {
    var id: UUID
    var moodImage: String
    var feeling: String
    var colorData: Data
    var note: String
    var date: Date

    init(id: UUID = UUID(), moodImage: ImageResource, feeling: String, color: Color, note: String, date: Date) {
        self.id = id
        self.moodImage = moodImage.rawValue
        self.feeling = feeling
        self.note = note
        self.date = date
        let uiColor = UIColor(color)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            self.colorData = data
        } else {
            self.colorData = Data()
        }
    }

    var color: Color {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            return Color(uiColor)
        } else {
            return Color.white
        }
    }

    var imageResource: ImageResource {
        ImageResource(rawValue: moodImage) ?? .none
    }
}
