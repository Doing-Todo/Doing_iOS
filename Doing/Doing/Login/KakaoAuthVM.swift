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
    @Published var userId: Int64? // 사용자 ID
    @Published var userName: String? // 사용자 닉네임
    
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
    
    //    func setUserInfo() {
    //        UserApi.shared.me() {(user, error) in
    //            if let error = error {
    //                print(error)
    //            }
    //            else {
    //                _ = user
    //                
    //                if let profile = user?.kakaoAccount?.profile{
    //                    let userName = profile.nickname
    //                    let profileImageUrl = profile.profileImageUrl?.absoluteString
    //                }
    //            }
    //        }
    //    }
    
    func setUserInfo() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print("Error fetching user info: \(error.localizedDescription)")
            } else {
                guard let user = user else {
                    print("User data is nil")
                    return
                }
                
                DispatchQueue.main.async {
                    self.userId = user.id
                    self.userName = user.kakaoAccount?.profile?.nickname
                    UserDefaults.standard.set(self.userName, forKey: "UserName")
                }
                
                print(UserDefaults.standard.string(forKey: "UserName") ?? "XX")
                print("User Info: \(self.userId ?? 0), \(self.userName ?? "No nickname")")
            }
        }
    }
    
    func handleLoginWithKakaoTalkApp() async -> Bool {
        
        await withCheckedContinuation {continuation in
            
            var isContinuationResumed = false
            
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                guard !isContinuationResumed else {
                    return
                }
                isContinuationResumed = true
                
                if let error = error {
                    print(error)
                    continuation.resume(returning: false)
                }
                else {
                    guard let oauthToken = oauthToken else {
                        continuation.resume(returning: false)
                        return
                    }
                    
                    UserDefaults.standard.set(true, forKey: "testLogin")
                    print("KakaoTalk login success, token: \(oauthToken.accessToken)")
                    
                    // 서버로 토큰 전달
                    self.sendTokenToServer(accessToken: oauthToken.accessToken) { success in
                        DispatchQueue.main.async {
                            self.isLoggedIn = success
                        }
                        continuation.resume(returning: success)
                    }
                }
            }
        }
    }
    
    func handleWithKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }
                
                guard let oauthToken = oauthToken else {
                    print("OAuth token missing")
                    continuation.resume(returning: false)
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "testLogin")
                print("Kakao account login success, token: \(oauthToken.accessToken)")
                
                // 서버로 토큰 전달
                self.sendTokenToServer(accessToken: oauthToken.accessToken) { success in
                    // 서버 응답에 따라 continuation 호출
                    if success {
                        DispatchQueue.main.async {
                            self.isLoggedIn = true
                        }
                        continuation.resume(returning: true)
                    } else {
                        continuation.resume(returning: false)
                    }
                }
            }
        }
    }
    
    
//    @MainActor
//    func handleKakaoLogin() {
//        
//        Task {
//            // 카카오톡 실행 가능 여부 확인 (카카오톡 설치 여부)
//            if (UserApi.isKakaoTalkLoginAvailable()) {
//                
//                // 카카오 앱을 통해 로그인
//                isLoggedIn = await handleLoginWithKakaoTalkApp()
//                setUserInfo() // 로그인 성공 시 사용자 정보 가져오기
//                
//            } else { // 설치 안되었있을 경우
//                // 카카오 웹뷰로 로그인
//                isLoggedIn = await handleWithKakaoAccount()
//                setUserInfo() // 로그인 성공 시 사용자 정보 가져오기
//            }
//        }
//    }
    
    @MainActor
    func handleKakaoLogin() {
        Task {
            // 먼저 기존의 액세스 토큰이 유효한지 확인
            if let accessToken = getToken() {
                // 토큰이 유효하지 않으면 갱신 시도
                let success = await refreshToken()
                if success {
                    // 토큰 갱신 후 사용자 정보 가져오기
                    setUserInfo()
                    isLoggedIn = true
                } else {
                    // 갱신 실패 시 로그인 절차 진행
                    if (UserApi.isKakaoTalkLoginAvailable()) {
                        // 카카오톡 앱을 통해 로그인
                        isLoggedIn = await handleLoginWithKakaoTalkApp()
                        setUserInfo() // 로그인 성공 시 사용자 정보 가져오기
                    } else {
                        // 카카오 웹뷰로 로그인
                        isLoggedIn = await handleWithKakaoAccount()
                        setUserInfo() // 로그인 성공 시 사용자 정보 가져오기
                    }
                }
            } else {
                // 기존 토큰이 없으면 로그인 진행
                if (UserApi.isKakaoTalkLoginAvailable()) {
                    // 카카오톡 앱을 통해 로그인
                    isLoggedIn = await handleLoginWithKakaoTalkApp()
                    setUserInfo() // 로그인 성공 시 사용자 정보 가져오기
                } else {
                    // 카카오 웹뷰로 로그인
                    isLoggedIn = await handleWithKakaoAccount()
                    setUserInfo() // 로그인 성공 시 사용자 정보 가져오기
                }
            }
        }
    }
    
    func storeToken(_ token: OAuthToken) {
        // 토큰 저장
        UserDefaults.standard.set(token.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(token.refreshToken, forKey: "refreshToken")
    }
    
    func getToken() -> String? {
            return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    // 토큰 갱신 함수
    func refreshToken() async -> Bool {
        await withCheckedContinuation { continuation in
            // refreshToken 메서드 호출
            AuthApi.shared.refreshToken { (oauthToken, error) in
                if let error = error {
                    print("Token refresh failed: \(error.localizedDescription)")
                    continuation.resume(returning: false)
                    return
                }
                
                guard let oauthToken = oauthToken else {
                    print("No token received after refresh.")
                    continuation.resume(returning: false)
                    return
                }
                
                // 갱신된 토큰 저장
                self.storeToken(oauthToken)
                print("Token refreshed successfully, new token: \(oauthToken.accessToken)")
                
                // 갱신된 토큰을 서버로 전송
                self.sendTokenToServer(accessToken: oauthToken.accessToken) { success in
                    continuation.resume(returning: success)
                }
            }
        }
    }

    
    private func sendTokenToServer(accessToken: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://ec2-3-36-52-28.ap-northeast-2.compute.amazonaws.com:8080/api/oauth/kakao") else {
            print("Invalid server URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // GET 요청일 경우, 쿼리 파라미터 추가
        if request.httpMethod == "GET" {
            let query = "?accessToken=\(accessToken)"
            guard let urlWithQuery = URL(string: url.absoluteString + query) else {
                print("Invalid query URL")
                completion(false)
                return
            }
            request.url = urlWithQuery
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Server request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server response error: \(response.debugDescription)")
                completion(false)
                return
            }
            
            print("Server response success")
            completion(true)
        }.resume()
    }
}
