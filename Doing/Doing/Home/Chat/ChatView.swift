//
//  ChatView.swift
//  Doing
//
//  Created by Jinhee on 11/10/24.
//

import SwiftUI

extension Color {
    static let c1 = Color("chat_1")
    static let me = Color("chat-color-me")
    static let date = Color("chat-notice")
}

struct ChatView: View {
    
    let chatRoom: ChatRoom
        @State private var messages: [Message] = []
        @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            // 날짜 표시
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 95, height: 25)
                    .background(Color.date)
                    .cornerRadius(50)
                Text(currentDateString())
                    .font(.headline)
                    .font(.system(size: 2))
                    .foregroundColor(.white)
            }.padding(.top, 10)
            
            // 메시지 목록
            ScrollView {
                ScrollViewReader { scrollViewProxy in
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .onChange(of: messages) { _ in
                        if let lastMessage = messages.last {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            .padding()
            
            // 입력 필드와 버튼
            HStack {
                TextField("메시지를 입력하세요...", text: $newMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .frame(height: 35)
                
                Button(action: sendMessage) {
                    Image("send")
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .background(Color.c1)
        .navigationTitle("채팅")
//        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let message = Message(id: UUID(), text: newMessage, isSentByCurrentUser: true, timestamp: Date())
        messages.append(message)
        newMessage = ""
    }
    
    private func currentDateString() -> String {
            let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
            return formatter.string(from: Date())
        }
}

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        VStack(alignment: message.isSentByCurrentUser ? .trailing : .leading, spacing: 5) {
            HStack {
                if message.isSentByCurrentUser {
                    Spacer()
                }
                Text(message.text)
                    .padding()
                    .background(message.isSentByCurrentUser ? Color.me : Color.white)
                    .foregroundColor(message.isSentByCurrentUser ? .white : .black)
                    .cornerRadius(20)
                if !message.isSentByCurrentUser {
                    Spacer()
                }
            }
            
            // 시간 표시
            Text(formatTime(from: message.timestamp))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: 300, alignment: message.isSentByCurrentUser ? .trailing : .leading)
    }
    
    private func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24시간 형식
        return formatter.string(from: date)
    }
}

//#Preview {
//    ChatView()
//}
