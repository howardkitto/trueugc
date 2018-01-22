//
//  model.swift
//  trueugc
//
//  Created by Howard Kitto on 22/01/2018.
//  Copyright © 2018 Howard Kitto. All rights reserved.
//

import Foundation
import LFLiveKit

struct Video: Codable {
    var _id : String?
    var title: String?
    var videoType: String?
    var status: String?
    var liveStreamStartedAt: String?
    var liveFeeds: [LiveFeed]?
}

struct LiveFeed: Codable {
    var _id: String?
    var label: String?
    var m3u8Url: String?
}

struct VideoSettings{
    var qualityLabel: String?
    var qualitySetting : LFLiveVideoQuality?
    var tmxServer: String?
}

struct CedexisCall: Codable{
    var providers:[Provider]?
}

struct Provider: Codable{
    var host : String?
    var provider : String?
}
