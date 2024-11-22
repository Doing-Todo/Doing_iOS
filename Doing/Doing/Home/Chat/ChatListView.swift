//
//  ChatListView.swift
//  Doing
//
//  Created by Jinhee on 11/16/24.
//

import SwiftUI

struct ChatListView: View {
    @State private var chatRooms: [ChatRoom] = [
        ChatRoom(id: UUID(), title: "user1", lastMessage: "안녕하세요!", timestamp: Date()),
        ChatRoom(id: UUID(), title: "user2", lastMessage: "점심 드셨나요?", timestamp: Date())
    ]
    @State private var searchText: String = ""
    
    var filteredChatRooms: [ChatRoom] {
        if searchText.isEmpty {
            return chatRooms
        } else {
            return chatRooms.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    TextField("검색", text: $searchText)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.top, 8)
                VStack(spacing: 16) { // 채팅방 목록을 수직 스택으로 정렬
                    ForEach(filteredChatRooms) { chatRoom in
                        NavigationLink(destination: ChatView(chatRoom: chatRoom)) {
                            HStack(spacing: 8) { // 이미지와 채팅방 정보 배치를 위한 수평 스택
                                Image("person")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle()) // 이미지 모양을 원형으로 설정
                                    .shadow(radius: 5) // 그림자 추가
                                
                                ChatRoomCell(chatRoom: chatRoom)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("채팅")
        }
    }
}

struct ChatRoomCell: View {
    let chatRoom: ChatRoom
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(chatRoom.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(chatRoom.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(formatTime(from: chatRoom.timestamp))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

#Preview {
    ChatListView()
}
