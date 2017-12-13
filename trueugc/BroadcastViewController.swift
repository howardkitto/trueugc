//
//  BroadcastViewController
//  trueugc
//
//  Created by Howard Kitto on 08/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

import LFLiveKit

class BroadcastViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var streamSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var previewView : UIView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var platformSwitch: UISwitch!
    @IBOutlet weak var watchLink: UIButton!
    @IBOutlet weak var currentQualityTextField: UITextField!
    
    let qualityPicker = UIPickerView()
    var streamKey = random()
    var prometheanServerURL = ""
    var prometheanWatchLink = "http://34.212.12.131:5000/state"
    var youTubeWatchLink = "https://www.youtube.com/channel/UCBdtpwW8S7G7JIE4eBNBDBQ"
    var serverURL = ""
    
    var outputQuality = (name: "medium3", setting: LFLiveVideoQuality.medium3)
    
    var encodeSettings: [(name : String, setting: LFLiveVideoQuality)] =
        [   ("Low1", LFLiveVideoQuality.low1),
            ("Low2", LFLiveVideoQuality.low2),
            ("Low3", LFLiveVideoQuality.low3),
            ("Medium 1", LFLiveVideoQuality.medium1),
            ("Medium 2", LFLiveVideoQuality.medium2),
            ("Medium 3", LFLiveVideoQuality.medium3),
            ("High 1", LFLiveVideoQuality.high1),
            ("High 2", LFLiveVideoQuality.high2),
            ("High 3", LFLiveVideoQuality.high3)]
    
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: outputQuality.setting)
        
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
        self.prometheanServerURL = "rtmp://34.212.12.131/live/\(streamKey)"
        self.serverURL = prometheanServerURL
        self.watchLink.setTitle(prometheanWatchLink, for: .normal)
        currentQualityTextField.inputView = qualityPicker
        qualityPicker.delegate = self
        currentQualityTextField.text = outputQuality.name
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return encodeSettings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return encodeSettings[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        outputQuality = encodeSettings[row]
        currentQualityTextField.text=encodeSettings[row].name
        currentQualityTextField.resignFirstResponder()
        session.stopLive()
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
            serverURL = prometheanServerURL
            self.watchLink.setTitle(prometheanWatchLink, for: .normal)
        }
        else{
            platformLabel.text = "YouTube"
            serverURL = "rtmp://a.rtmp.youtube.com/live2/99cu-uuf8-w2zx-9rrs"
            self.watchLink.setTitle(youTubeWatchLink, for: .normal)
            
        }
    }
    
    @IBAction func watchLinkClicked(_ sender: Any) {
        if let url = URL(string: watchLink.currentTitle!){
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                print("Opened")
                })
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

