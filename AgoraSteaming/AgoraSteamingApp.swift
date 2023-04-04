//
//  AgoraSteamingApp.swift
//  AgoraSteaming
//
//  Created by Alikhan Tursunbekov on 23/3/23.
//

import SwiftUI
import AVFoundation

class CameraManager : ObservableObject {
    @Published var permissionGranted = false
    @Published var microPermission = false
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                self.permissionGranted = accessGranted
            }
        })
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: {accessGranted in
            DispatchQueue.main.async {
                self.microPermission = accessGranted
            }
        })
    }
}

@main
struct AgoraSteamingApp: App {
    @StateObject var cameraManager = CameraManager()
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(){
                cameraManager.requestPermission()
            }
        }
    }
}
