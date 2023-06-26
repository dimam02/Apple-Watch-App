//
//  ContentView.swift
//  Progress App
//
//  Created by Dmytro on 07.06.2023.
//

import SwiftUI
import UserNotifications

struct UserProfile {
    var name: String
    var goals: [String]
    var progressHistory: [Double]
    // Additional properties and methods related to user profile management
}



struct ContentView: View {
    @State private var progress: Double = 0.0
    @State private var timeLeft: TimeInterval = 0.0
    @State private var userProfile = UserProfile(name: "John Doe", goals: [], progressHistory: [])
    
    let milestoneValues: [Double] = [0.5, 0.8, 1.0] // Milestone completion values
    
    func updateProgress() {
        // Update progress logic based on user actions
        progress += 0.1 // Example: Increment progress by 0.1 for demonstration
        
        // Check if any milestone reached and schedule notification
        for milestone in milestoneValues {
            if progress >= milestone && progress - 0.1 < milestone {
                scheduleNotification(milestone: milestone)
            }
        }
        
        // Calculate and update time left
        let totalTime: TimeInterval = 10 * 60 // Example: Total time in seconds
        timeLeft = (1 - progress) * totalTime
    }
    
    func scheduleNotification(milestone: Double) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Milestone Reached!"
        notificationContent.body = "You have reached \(Int(milestone * 100))% completion."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Progress: \(Int(progress * 100))%")
                .font(.title)
                .padding()
            
            Button(action: {
                updateProgress()
                userProfile.progressHistory.append(progress)
            }) {
                Text("Update Progress")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("Time Left: \(Int(timeLeft / 60)) minutes")
                .font(.headline)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
