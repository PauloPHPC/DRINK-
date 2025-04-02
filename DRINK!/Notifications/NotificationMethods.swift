//
//  NotificationMethods.swift
//  DRINK!
//
//  Created by Paulo Cerqueira on 13/03/2025.
//

import Foundation
import UserNotifications

struct NotificationMethods {
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { allowed, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
                return
            }
            
        }
    }
    
    func dispatchNotification(startTime: Date, endTime: Date, recomendedAmount: Double) {
        
        // Conteúdo padrão da notificação.
        let title = "it's time to get hydrated"
        let body = "This is your reminder to stay hydrated! DRINK SOME WATER!"
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        // Calcular o numero de copos a serem tomados
        let numberOfCups = recomendedAmount/0.25
        
        // Calcular o intervalo de tempo entre o final e o começo. SEGUNDOS
        let totalTimeInterval = endTime.timeIntervalSince(startTime)
        
        // Divide o total de segundos pelo numero de copos a serem tomados. transformado em Minutos.
        let interval = totalTimeInterval/Double(numberOfCups - 1.0)
        
        print("Número de copos: \(Int(numberOfCups))")
        print("Intervalo entre notificações: \(interval) segundos")
        
        let calendar = Calendar.current
        var notificationTime = startTime
                
        for i in 1...(Int(numberOfCups)+1) {
            
            
            let components = calendar.dateComponents([.hour, .minute], from: notificationTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let identifier = "Notification_\(i)"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Sucesso")
                }
        
            }
            
            if let nextTime = calendar.date(byAdding: .second, value: Int(interval), to: notificationTime) {
                notificationTime = nextTime
            } else {
                break
            }
        }
        
        
        
        
    }
    
    func scheduleNotification(startTime: Date, endTime: Date, recomendedAmount: Double) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                dispatchNotification(startTime: startTime, endTime: endTime, recomendedAmount: recomendedAmount)
            case .denied:
                print("denied")
            case .notDetermined:
                requestNotificationPermissions()
            default:
                return
            }
        }
        
    }
}

