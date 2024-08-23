//
//  AppLocalized.swift
//  MoodList
//
//  Created by 강치우 on 8/23/24.
//

import Foundation

public enum AppLocalized {
    // Mood
    public static let feelingAngry = "화나요"
    public static let feelingSad = "우울해요"
    public static let feelingNomal = "그저 그래요"
    public static let feelingGood = "좋아요"
    public static let feelingHappy = "행복해요"
    
    public static let moodFirstText = "지금 내가 느끼는"
    public static let moodSecondText = "무드는"
    
    public static let welcomeMessages = [
        "환영해요!\n오늘 당신의 무드를 여기 남겨보세요",
        "하루의 무드를 기록하는 순간,\n당신의 이야기를 들려주세요",
        "오늘의 무드는 어떤 색인가요?\n같이 기록해요",
        "하루의 끝,\n당신의 무드를 이야기해 주세요",
        "지금 이 순간의 무드는 어떤가요?\n함께 기록해 봐요",
        "당신의 이야기를 들려주세요.\n무드를 기록할 준비가 되었나요?",
        "오늘 하루,\n당신의 무드는 어떤 색인가요?",
        "하루를 마무리하며,\n오늘의 무드를 남겨보세요"
    ]
    
    public static let noMoodEntriesText = "등록된 무드가 없습니다."
    public static let writeMoodText = "무드를 작성하세요"
    public static let moodNotePlaceholder = "오늘 당신의 무드는 어땠나요?"
    public static let registerButtonText = "등록"
    
    // Date/Time formatting
    public static let dateFormat = "M월 d일"
    public static let timeFormat = "HH시 mm분"
    
    // Error Message
    public static let errorAlertMessage = "무드를 등록 할 수 없습니다"
    public static let errorAlertText = "무드를 저장하는 도중 오류가 발생했습니다. 다시 시도해 주세요."
}
