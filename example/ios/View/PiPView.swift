//
//  PictureInPictureView.swift
//  Runner
//
//  Created by lambiengcode on 06/12/2022.
//

import UIKit
import AVKit
import flutter_webrtc

class PictureInPictureView: UIView {
    // MARK: Private
    private var myUserNameCard: UserCardView = UserCardView()
    private var localView: UIView = UIView()
    private var rtcRenderer: RTCMTLVideoView? = nil
    private var peerConnectionId: String? = nil
    private var remoteStreamId: String? = nil
    private var isLocalCameraEnable: Bool = false
    private var isRemoteCameraEnable: Bool = false
    
    private var pictureInPictureIsRunning: Bool = false
    
    // MARK: Funcs
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        // MARK: Setup subviews
        localView = UIView()
        localView.clipsToBounds = true
        
        // MARK: add to parent view
        addSubview(localView)
        configurationLayoutConstrains()
        
        // MARK: add user card view to subviews
        self.addAvatarView()
        self.configurationLayoutConstraintUserNameCard()
    }
    
    func addAvatarView() {
        // Add local and remote avatar
        myUserNameCard = UserCardView()
        myUserNameCard.setUserName(userName: "You")
        myUserNameCard.contentMode = .scaleAspectFit
        localView.addSubview(myUserNameCard)
    }
    
    func initParameters(peerConnectionId: String, remoteStreamId: String, isRemoteCameraEnable: Bool, myAvatar: String) {
        self.peerConnectionId = peerConnectionId
        self.remoteStreamId = remoteStreamId
        self.isRemoteCameraEnable = isRemoteCameraEnable
        
        self.myUserNameCard.setAvatar(avatar: myAvatar)
    }
    
    func updateStateValue(isRemoteCameraEnable: Bool) {
        if (self.isRemoteCameraEnable != isRemoteCameraEnable) {
            self.isRemoteCameraEnable = isRemoteCameraEnable
            
            if (!self.pictureInPictureIsRunning) {
                return
            }
            
            if (self.isRemoteCameraEnable) {
                self.addRemoteRendererToView()
            } else {
                self.rtcRenderer?.removeFromSuperview()
            }
        }
    }
    
    func configurationLayoutConstrains() {
        // Enable Autolayout
        localView.translatesAutoresizingMaskIntoConstraints = false
        
        localView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        localView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        localView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        localView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func configurationLayoutConstraintForRenderer() {
        if (self.rtcRenderer == nil) {
            return
        }
        
        self.rtcRenderer!.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func configurationLayoutConstraintUserNameCard() {
        myUserNameCard.translatesAutoresizingMaskIntoConstraints = false
        
        let constraintsLocal = [
            self.myUserNameCard.leadingAnchor.constraint(equalTo: localView.leadingAnchor),
            self.myUserNameCard.trailingAnchor.constraint(equalTo: localView.trailingAnchor),
            self.myUserNameCard.topAnchor.constraint(equalTo: localView.topAnchor),
            self.myUserNameCard.bottomAnchor.constraint(equalTo: localView.bottomAnchor)
        ]
    
        self.localView.addConstraints(constraintsLocal)
        self.myUserNameCard.bounds = self.localView.frame
    }
    
    func configurationVideoView() {
        if (remoteStreamId == nil || peerConnectionId == nil) {
            return
        }
        
        if #available(iOS 15.0, *) {
            // Remote
            if (self.isRemoteCameraEnable) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.addRemoteRendererToView()
                }
            }
        }
    }
    
    func addRemoteRendererToView() {
        self.rtcRenderer = RTCMTLVideoView()
        self.rtcRenderer!.contentMode = .scaleAspectFit
        self.rtcRenderer!.videoContentMode = .scaleAspectFill
        
        // Get RemoteMTLVideoView
        let mediaRemoteStream = FlutterWebRTCPlugin.sharedSingleton().stream(forId: self.remoteStreamId, peerConnectionId: self.peerConnectionId)
        mediaRemoteStream?.videoTracks.first?.add(self.rtcRenderer!)
        
        self.configurationLayoutConstraintForRenderer()
    }
    
    func updateLayoutVideoVideo() {
        self.stopPictureInPictureView()
        
        self.pictureInPictureIsRunning = true
        self.myUserNameCard.isHidden = false
        
        // MARK: add video view
        self.configurationVideoView()
    }
    
    
    // MARK: release variables
    func disposeVideoView() {
        remoteStreamId = nil
        peerConnectionId = nil
    }
    
    func stopPictureInPictureView() {
        self.pictureInPictureIsRunning = false
        self.myUserNameCard.isHidden = true
        self.rtcRenderer?.removeFromSuperview()
    }
}
