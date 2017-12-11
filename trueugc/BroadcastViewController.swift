//
//  BroadcastViewController
//  trueugc
//
//  Created by Howard Kitto on 08/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit
import LFLiveKit

class BroadcastViewController: UIViewController {
    

    @IBOutlet weak var streamSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var previewView : UIView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var platformSwitch: UISwitch!
    
    var streamKey = random()
    var prometheanServerURL = ""
    var serverURL = ""
    
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .medium3)
        
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)!
        session.delegate = self
        session.captureDevicePosition = .back
        session.preView = self.previewView
        return session
    }()
    
    static func random(_ length: Int = 4) -> String {
        let base = "abcdefghijklmnopqrstuvwxyz"
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 23/255, green:53/255, blue: 97/255, alpha: 1)
        self.prometheanServerURL = "rtmp://34.212.12.131/live/\(streamKey)"
        self.serverURL = prometheanServerURL
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.running = true
    }
    
    
    @IBAction func switchStream(_ sender: Any) {
        if streamSwitch.isOn{
            let stream = LFLiveStreamInfo()
            stream.url = serverURL
            session.startLive(stream)
        }
        else{
            session.stopLive()
        }
        
    }
    
    @IBAction func switchPlatform(_ sender: Any) {
        if platformSwitch.isOn{
            platformLabel.text = "Promethean"
//            serverURL = "rtmp://34.212.12.131/live/foobah2"
            serverURL = prometheanServerURL
        }
        else{
            platformLabel.text = "YouTube"
            serverURL = "rtmp://a.rtmp.youtube.com/live2/99cu-uuf8-w2zx-9rrs"
            
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
            infoLabel.text = "start"
        case.stop:
            infoLabel.text = "stop"
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


