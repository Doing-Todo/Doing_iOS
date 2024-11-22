//
//  Chat.swift
//  Doing
//
//  Created by Jinhee on 11/16/24.
//

import Foundation

struct ChatRoom: Identifiable {
    let id: UUID
    let title: String
    let lastMessage: String
    let timestamp: Date
}

struct Message: Identifiable, Equatable {
    let id: UUID
    let text: String
    let isSentByCurrentUser: Bool
    let timestamp: Date
}
