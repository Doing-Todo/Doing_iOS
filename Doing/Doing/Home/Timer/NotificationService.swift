//
//  NotificationService.swift
//  Doing
//
//  Created by Jinhee on 10/26/24.
//

import UserNotifications

struct NotificationService {
    func sendNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "타이머 종료!"
                content.body = "설정한 타이머가 종료되었습니다."
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request) // 알림을 추가
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("알림을 추가하는 중 오류 발생: \(error.localizedDescription)")
                    } else {
                        print("알림이 성공적으로 등록되었습니다.")
                    }
                }
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
