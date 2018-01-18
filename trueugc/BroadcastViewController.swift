//
//  BroadcastViewController
//  trueugc
//
//  Created by Howard Kitto on 08/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

import LFLiveKit

class BroadcastViewController: UIViewController{
    
    @IBOutlet weak var streamSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var previewView : UIView!
    
//    @IBOutlet weak var tmxSwitch: UISegmentedControl!
    @IBOutlet weak var watchLink: UILabel!
    
    var newVideo:Video?
    var videoSettings:VideoSettings?
    var streamKey: String? = ""
    var tmxUrl = String()
    
    //default to us-east-1
    
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: (videoSettings?.qualitySetting!)!)
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.previewView
        return session
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        streamKey = newVideo?._id!
        tmxUrl = (videoSettings?.tmxServer!)!
        
        print("got this \(String(describing: newVideo))")
        print("outputQuality Label\(String(describing: videoSettings?.qualityLabel!))")
        watchLink.text = newVideo?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.running = true
    }
    
    
    @IBAction func switchStream(_ sender: Any) {
        if streamSwitch.isOn{
            
            if newVideo?._id == ""{
                print("error")
            }
            else{
                let stream = LFLiveStreamInfo()
                stream.url = "rtmp://\(String(tmxUrl))/live/\(String(describing: streamKey!))"
                print("connecting to \(String(describing: stream.url))")
                session.startLive(stream)}
        }
        else{
            session.stopLive()
        }
        
    }
}

extension BroadcastViewController: LFLiveSessionDelegate {
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        switch state {
        case .error:
            infoLabel.text = "error"
        case .pending:
            infoLabel.text = "pending"
        case .ready:
            infoLabel.text = "ready"
        case.start:
            infoLabel.text = "streaming!"
        case.stop:
            infoLabel.text = "stopped"
        case .refresh:
            infoLabel.text = "refreshing"
        }
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("error: \(errorCode)")
        
    }
}


