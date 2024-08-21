//
//  HapticFeedbackManager.swift
//  MoodList
//
//  Created by 강치우 on 8/21/24.
//

import UIKit

public final class HapticFeedbackManager {
    
    public static let shared = HapticFeedbackManager()

    public let generator = UIImpactFeedbackGenerator(style: .soft)
    
    public init() {
        generator.prepare()
    }
    
    public func triggerHapticFeedback() {
        generator.impactOccurred()
    }
}
