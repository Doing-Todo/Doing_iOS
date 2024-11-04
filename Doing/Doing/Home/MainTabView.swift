//
//  MainTabView.swift
//  Doing
//
//  Created by Jinhee on 9/29/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var pathModel: PathModel
    @StateObject private var mainTabViewModel = MainTabViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $mainTabViewModel.selectedTab) {
                TodoListView()
                    .tabItem {
                        Image(systemName: "checklist")
                    }
                    .tag(Tab.todoList)
                MemoListView()
                    .tabItem {
                        Image(systemName: "square.and.pencil")
                    }
                    .tag(Tab.memo)
                VoiceRecorderView()
                    .tabItem {
                        Image(systemName: "waveform")
                    }
                    .tag(Tab.voiceRecorder)
                TimerView()
                    .tabItem {
                        Image(systemName: "timer")
                    }
                    .tag(Tab.timer)
                SettingView()
                    .tabItem {
                        Image(systemName: "gearshape")
                    }
                    .tag(Tab.setting)
            }
            .accentColor(.blue)
            .environmentObject(mainTabViewModel)
            
            SeperatorLineView()
        }
    }
}

private struct SeperatorLineView: View {
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      Rectangle()
        .fill(
          LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .frame(height: 10)
        .padding(.bottom, 60)
    }
  }
}

#Preview {
    MainTabView()
        .environmentObject(PathModel())
        .environmentObject(TodoListViewModel())
        .environmentObject(MemoListViewModel())
}
