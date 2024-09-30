//
//  SettingView.swift
//  Doing
//
//  Created by Jinhee on 9/29/24.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject var kakaoAuthVM : KakaoAuthVM = KakaoAuthVM()
    
    var body: some View {
        VStack {
            Button(action: {
                kakaoAuthVM.kakaoLogout()
            }, label: {
                Text("로그아웃")
                    .frame(width: 90, height: 30)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color.red))
            })
        }
    }
}

#Preview {
    SettingView()
}
