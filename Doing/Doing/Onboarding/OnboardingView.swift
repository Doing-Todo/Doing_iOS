//
//  OnboardingView.swift
//  Doing
//
//  Created by Jinhee on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var pathModel = PathModel()
    @StateObject private var todoListViewModel = TodoListViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            TodoListView()
                .environmentObject(todoListViewModel)
                .navigationDestination(
                    for: PathType.self,
                    destination: { pathType in
                        switch pathType {
                        case .maintabView:
                            MainTabView()
                                .navigationBarBackButtonHidden()
                                .environmentObject(todoListViewModel)
                            
                        case .todoView:
                            TodoView()
                                .navigationBarBackButtonHidden()
                                .environmentObject(todoListViewModel)
                        }
                    }
                )
        }
        .environmentObject(pathModel)
    }
}

#Preview {
    OnboardingView()
}
