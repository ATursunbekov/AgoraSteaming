import SwiftUI
import AgoraRtcKit
import AgoraUIKit

extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}

class AgoraViewerHelper: AgoraVideoViewerDelegate {
    static var agview: AgoraViewer = {
        var agSettings = AgoraSettings()
        agSettings.videoConfiguration = .init(size: CGSize(width: 480, height: 360), frameRate: .fps24, bitrate: AgoraVideoBitrateStandard, orientationMode: .fixedPortrait, mirrorMode: .auto)
        agSettings.enabledButtons = [.cameraButton, .micButton, .flipButton]
        return AgoraViewer(
            connectionData: AgoraConnectionData(
                appId: AppKeys.agoraAppId, rtcToken: AppKeys.agoraToken
            ),
            style: .floating,
            agoraSettings: agSettings,
            delegate: AgoraViewerHelper.delegate
        )
    }()
    static var agAudience: AgoraViewer = {
        var agSettings = AgoraSettings()
        agSettings.videoConfiguration = .init(size: CGSize(width: 480, height: 360), frameRate: .fps24, bitrate: AgoraVideoBitrateStandard, orientationMode: .fixedPortrait, mirrorMode: .auto)
        agSettings.enabledButtons = [.micButton, .flipButton] // disable camera button
        return AgoraViewer(
            connectionData: AgoraConnectionData(
                appId: AppKeys.agoraAppId, rtcToken: AppKeys.agoraToken
            ),
            style: .floating,
            agoraSettings: agSettings,
            delegate: AgoraViewerHelper.delegate
        )
    }()
    static var delegate = AgoraViewerHelper()
}

struct ContentView: View {
    @State var joinedChannel: Bool = false
    @State var userType = true
    
    var body: some View {
        ZStack {
            VStack {
                if userType {
                    AgoraViewerHelper.agview
                } else {
                    AgoraViewerHelper.agAudience
                }
                Button("Leave Channel") {
                    AgoraViewerHelper.agview.viewer.leaveChannel()
                    AgoraViewerHelper.agAudience.viewer.leaveChannel() // Add a button to allow the audience member to leave the channel
                    joinedChannel = false
                }
                .padding()
                .foregroundColor(.white)
                .background(Capsule().foregroundColor(.red))
            }
            if !joinedChannel {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    Button {
                        userType = true
                        self.joinChannel()
                    } label: {
                        Text("Join channel as broadcaster")
                            .padding()
                            .foregroundColor(.black)
                            .background(Capsule().foregroundColor(.white))
                    }
                    Button {
                        userType = false
                        self.joinChannel()
                    } label: {
                        Text("Join channel as audence")
                            .padding()
                            .foregroundColor(.black)
                            .background(Capsule().foregroundColor(.white))
                    }
                }
            }
        }
    }
    
    func joinChannel() {
        self.joinedChannel = true
        if userType {
            AgoraViewerHelper.agview.join(
                channel: "Stream", with: AppKeys.agoraToken,
                as: .broadcaster
            )
        } else {
            AgoraViewerHelper.agAudience.join(
                channel: "Stream", with: AppKeys.agoraToken,
                as: .audience
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
