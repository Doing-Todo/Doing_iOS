//
//  DoingApp.swift
//  Doing
//
//  Created by Jinhee on 9/23/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct DoingApp: App {
    
    @UIApplicationDelegateAdaptor var appDelegate : MyAppDelegate
    
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
