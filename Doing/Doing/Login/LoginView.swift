//
//  LoginView.swift
//  Doing
//
//  Created by Jinhee on 9/23/24.
//

import SwiftUI

struct LoginView: View {
        
    @StateObject var kakaoAuthVM : KakaoAuthVM = KakaoAuthVM()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Doing")
                    .font(.system(size: 45))
                    .foregroundColor(.blue)
                Spacer()
                Button(action: {
                    kakaoAuthVM.handleKakaoLogin()
                }) {
                    Image("kakao")
                        .resizable()
                        .frame(width: 240, height: 45)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
}
