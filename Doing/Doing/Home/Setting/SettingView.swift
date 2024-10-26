//
//  SettingView.swift
//  Doing
//
//  Created by Jinhee on 9/29/24.
//

import SwiftUI

struct SettingView: View {
    
    @StateObject var kakaoAuthVM : KakaoAuthVM = KakaoAuthVM()
    @EnvironmentObject private var mainTabViewModel: MainTabViewModel
    
    var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 35)
            
            TotalTabCountView()
            
            Spacer()
                .frame(height: 40)
            
            TotalTabMoveView()
            
            Spacer()
                .frame(height: 40)
            
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
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

// MARK: - 전체 탭 설정된 카운트 뷰
private struct TotalTabCountView: View {
    @EnvironmentObject private var mainTabViewModel: MainTabViewModel
    
    fileprivate var body: some View {
        HStack {
            TabCountView(title: "To do", count: mainTabViewModel.todosCount)
            
            Spacer()
                .frame(width: 70)
            
            TabCountView(title: "메모", count: mainTabViewModel.memosCount)
            
            Spacer()
                .frame(width: 70)
            
            TabCountView(title: "음성메모", count: mainTabViewModel.voiceRecordersCount)
        }
    }
}

// MARK: - 각 탭 설정된 카운트 뷰 (공통 뷰 컴포넌트)
private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(
        title: String,
        count: Int
    ) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.black)
            
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTabMoveView: View {
    @EnvironmentObject private var mainTabViewModel: MainTabViewModel
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
            
            TabMoveView(
                title: "To do List",
                tabAction: {
                    mainTabViewModel.changeSelectedTab(.todoList)
                }
            )
            
            TabMoveView(
                title: "메모장",
                tabAction: {
                    mainTabViewModel.changeSelectedTab(.memo)
                }
            )
            
            TabMoveView(
                title: "음성메모",
                tabAction: {
                    mainTabViewModel.changeSelectedTab(.voiceRecorder)
                }
            )
            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
        }
    }
}

// MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(
        title: String,
        tabAction: @escaping () -> Void
    ) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button(
            action: tabAction,
            label: {
                HStack {
                    Text(title)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                    
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        )
        .padding(.all, 20)
    }
}


#Preview {
    SettingView()
        .environmentObject(MainTabViewModel())
}
