//
//  KakaoAuthVM.swift
//  Doing
//
//  Created by Jinhee on 9/29/24.
//

import Foundation
import Combine
import KakaoSDKAuth
import KakaoSDKUser

class KakaoAuthVM: ObservableObject {
    
    @Published var isLoggedIn : Bool = false
    
    func kakaoLogout() {
        Task {
            if await handleKakaoLogout() {
                isLoggedIn = false
            }
        }
    }
    
    func handleKakaoLogout() async -> Bool {
        
        await withCheckedContinuation{ continutaion in
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                    continutaion.resume(returning: false)
                }
                else {
                    UserDefaults.standard.set(false, forKey: "testLogin")
                    print("logout() success.")
                    continutaion.resume(returning: true)
                    
                }
            }
        }
    }
    
    func setUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                _ = user
                
                if let profile = user?.kakaoAccount?.profile{
                    let userName = profile.nickname
                    let profileImageUrl = profile.profileImageUrl?.absoluteString
                }
            }
        }
    }
    
    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        
        await withCheckedContinuation {continuation in
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    UserDefaults.standard.set(true, forKey: "testLogin")
                    print("loginWithKakaoTalk() success.")
                    
                    _ = oauthToken
                    continuation.resume(returning: true)
                    self.setUserInfo()
                }
            }
        }
    }
    
    func handleWithKakaoAccount() async -> Bool {
        
        await withCheckedContinuation{ continuation in
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    UserDefaults.standard.set(true, forKey: "testLogin")
                    print("loginWithKakaoAccount() success.")
                    
                    _ = oauthToken
                    continuation.resume(returning: true)
                    self.setUserInfo()
                }
            }
        }
    }
    
    @MainActor
    func handleKakaoLogin() {
        
        Task {
            // 카카오톡 실행 가능 여부 확인 (카카오톡 설치 여부)
            if (UserApi.isKakaoTalkLoginAvailable()) {
                
                // 카카오 앱을 통해 로그인
                isLoggedIn = await handleLoginWithKakaoTalkApp()
                
            } else { // 설치 안되었있을 경우
                // 카카오 웹뷰로 로그인
                isLoggedIn = await handleWithKakaoAccount()
            }
        }
    }
}
