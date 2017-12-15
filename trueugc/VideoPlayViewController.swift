//
//  VideoPlayViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 14/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

class VideoPlayViewController: UIViewController {
    
    @IBOutlet weak var VideoTitle: UILabel!
    
    @IBOutlet weak var streamUrl: UILabel!
    
    
    @IBOutlet weak var VideoPLayer: UIView!
    
    var video:Video?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VideoTitle.text = video?.title
        
//        streamUrl.text = video?.liveFeeds![0].m3u8Url

    }

    

}
