//
//  SplashView.swift
//  Doing
//
//  Created by Jinhee on 9/23/24.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    @StateObject var kakaoAuthVM : KakaoAuthVM = KakaoAuthVM()
    @AppStorage("testLogin") var testLogin : Bool = UserDefaults.standard.bool(forKey: "testLogin")
    
    var body: some View {
        ZStack {
            if self.isActive {
                if testLogin {
                    MainTabView()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                }
                else {
                    LoginView()
                }
            } else {
                Text("Doing")
                    .font(.system(size: 45))
                    .foregroundColor(.blue)
//                Image("logo").resizable().scaledToFit().frame(width: 120, height: 100)
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation{self.isActive = true}
            }
        }
    }
}

#Preview {
    SplashView()
}
