//
//  HomeListViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 13/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

struct Video: Decodable {
    let id : String?
    let title: String?
}


class HomeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int )-> Int{
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath : IndexPath) ->
        UITableViewCell{
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = videos[indexPath.row].title
            return cell
    }
    
    
    
    @IBOutlet weak var videoList: UITableView!
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func downloadJSON(completed: @escaping () -> ()){
            let url = URL(string: "https://api.overloop.io/org/true/search-videos?search=game&videoType=live")
        
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error == nil {
                    do{
                        self.videos = try JSONDecoder().decode([Video].self, from: data!)
                        print(self.videos)
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
