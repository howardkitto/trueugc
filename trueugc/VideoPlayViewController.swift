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
    
    var video:Video?
    
    var streamUrl :String?
    
    var cedexisDecision = CedexisCall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streamUrl = video?.liveFeeds![0].m3u8Url
        
        VideoTitle.text = video?.title
        
        callCedexis()
        
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        guard let url = URL(string: streamUrl!) else {
            return
        }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
       
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }
    
    func callCedexis(){
        
        func getBestCDN(completed: @escaping ()->()){
            let url = URL(string : "https://hopx.cedexis.com/zones/1/customers/54877/apps/1/decision/" )
            
            URLSession.shared.dataTask(with: url!){(data, response, error)in
                if error == nil {
                    do{
                        self.cedexisDecision = try
                            JSONDecoder().decode(CedexisCall.self, from: data!)
                        print(self.cedexisDecision.providers![0].provider!)
                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
        }
        getBestCDN {

        }
    }

}
