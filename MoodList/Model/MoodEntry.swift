//
//  MoodEntry.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct MoodEntry: Identifiable, Codable {
    let id: UUID
    let moodImage: String
    let feeling: String
    let colorData: Data
    let note: String
    let date: Date

    var color: Color {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            return Color(uiColor)
        } else {
            return Color.white // 변환이 실패할 경우 기본 색상으로 white를 사용
        }
    }

    var imageResource: ImageResource {
        ImageResource(rawValue: moodImage) ?? .none
    }

    init(id: UUID = UUID(), moodImage: ImageResource, feeling: String, color: Color, note: String, date: Date) {
        self.id = id
        self.moodImage = moodImage.rawValue
        self.feeling = feeling
        self.note = note
        self.date = date
        // Color를 UIColor로 변환하고, Data로 인코딩하여 저장
        let uiColor = UIColor(color)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) {
            self.colorData = data
        } else {
            self.colorData = Data()
        }
    }
}
