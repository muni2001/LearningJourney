//
//  OnboardingViewModel.swift
//  LearningJourney
//
//  Created by Monerah Almousa on 30/05/1448 AH.
//

import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    // 1. المتغيرات التي تراقبها الواجهة لتحديث نفسها تلقائياً
    @Published var learningSubject: String = ""
    @Published var selectedDuration: String = "Week"
    
    // الخيارات الثابتة لفترات التعلم
    let durations = ["Week", "Month", "Year"]
    
    // 2. التحقق من صحة المدخلات (إجباري ألا يكون الحقل فارغاً)
    var isFormValid: Bool {
        return !learningSubject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // 3. دالة عند الضغط على زر البدء
    func startLearningTapped() {
        if learningSubject.lowercased() == "swift" {
            print("Great! User wants to learn: Swift in a \(selectedDuration)")
        } else {
            print("Please type Swift to proceed.")
        }
    }
}
