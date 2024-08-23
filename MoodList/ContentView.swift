//
//  ContentView.swift
//  MoodList
//
//  Created by 강치우 on 8/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoodViewModel()
    
    var body: some View {
        NavigationStack {
            MainView()
                .alert(isPresented: $viewModel.showingErrorAlert) {
                    Alert(title: Text(AppLocalized.errorAlertMessage),
                          message: Text(viewModel.errorMessage),
                          dismissButton: .default(Text("확인")))
                }
        }
    }
}
