//
//  MainTabView.swift
//  Doing
//
//  Created by Jinhee on 9/29/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TodoListView()
                .tabItem {
                    Image(systemName: "checklist")
                }
            MemoView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                }
            RecordingView()
                .tabItem {
                    Image(systemName: "waveform")
                }
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape")
                }
        }.accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
