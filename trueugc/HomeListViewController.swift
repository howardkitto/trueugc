//
//  HomeListViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 13/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

struct Video: Codable {
    let _id : String?
    let title: String?
    let liveFeeds: [LiveFeed]?
}

struct LiveFeed: Codable {
    let _id: String?
    let label: String?
    let m3u8Url: String?
}


class HomeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var videos = [Video]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int )-> Int{
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) ->
        UITableViewCell{
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = videos[indexPath.row].title
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "playVideo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoPlayViewController{
            destination.video = videos[(videoList.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    @IBOutlet weak var videoList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var videoQuery = "videoType=Live"
        
//      var videoQuery = "videoType=Live&liveStreamStatus=Live"
        
        func downloadJSON(completed: @escaping () -> ()){
            let url = URL(string: "https://api.overloop.io/org/true/videos?\(videoQuery)")
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do{
                        self.videos = try JSONDecoder().decode([Video].self, from: data!)
//                        print(self.videos)
                        DispatchQueue.main.async {
                            completed()
                        }                    }
                    catch{
                        print(error)
                    }
                }
            }.resume()
        }
        downloadJSON {
            self.videoList.reloadData()
        }
        
        videoList.delegate = self
        videoList.dataSource = self
        
        
    }
    
}
