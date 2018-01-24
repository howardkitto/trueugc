//
//  VideoPlayViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 14/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayViewController: UIViewController {
    
    @IBOutlet weak var VideoTitle: UILabel!
    
    @IBOutlet weak var streamUrlLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    var video:Video?
    
    var streamUrl :URL?
    
    var cedexisDecision = CedexisCall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VideoTitle.text = video?.title
        
        self.playButton.isHidden=true
        
        getBestCDN()
        
    }
    
    @IBAction func playVideo(_ sender: Any) {

        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: streamUrl!)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    func createURLWithComponents(cmsURL: String, cedexisHost: String)->URL?{
        
        let cmsURLComponents = URLComponents.init(string: cmsURL)
        let videoPath =  String(describing: cmsURLComponents!.path)
        
        var returnURLString = String()
        
        if(self.cedexisDecision.providers![0].provider!=="fastly_ssl"){
            //this is an awful hack
            returnURLString = "\(cedexisHost)/video-true-ugc.promethean.tv\(videoPath)"
//            print(returnURLString)
        }
        else{returnURLString = "\(cedexisHost)\(videoPath)"}
        
        let gluedURL = URL(string: returnURLString)
        
        return gluedURL
    }
    
    func getBestCDN(){
            let cedexisUrl = URL(string : "https://hopx.cedexis.com/zones/1/customers/54877/apps/1/decision/")
            
            URLSession.shared.dataTask(with: cedexisUrl!){(data, response, error)in
                if error == nil {
                    do{
                        self.cedexisDecision = try
                            JSONDecoder().decode(CedexisCall.self, from: data!)
                        let cedexisProvider = self.cedexisDecision.providers![0].provider!
                        let cedexisHost = self.cedexisDecision.providers![0].host!
                        let streamUrl = self.video?.liveFeeds![0].m3u8Url!
                        let newURL = self.createURLWithComponents(cmsURL: streamUrl!, cedexisHost: cedexisHost)

                        self.streamUrl=newURL!
                        
                        //change the UI when Cedexis returns data
                        DispatchQueue.main.async(execute: {
                            self.streamUrlLabel.text=cedexisProvider
                            self.playButton.isHidden=false
//                            print(cedexisHost)
                        })

                    }
                    catch{
                        print("this error \(error)")
                    }
                }
            }.resume()
        }
}
