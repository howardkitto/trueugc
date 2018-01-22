//
//  HomeListViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 13/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit

extension UITableView{
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

class HomeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var videos = [Video]()
    
    var videoQuery = "videoType=Live&liveStreamStatus=Live&orderBy=liveStreamStartedAt"
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoPlayViewController{
            destination.video = videos[(videoList.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    @IBOutlet weak var videoList: UITableView!
    
    @IBOutlet weak var videoTypeSwitch: UISwitch!
    @IBOutlet weak var videoTypeLabel: UILabel!
    
    @IBAction func reloadList(_ sender: Any) {
        
        getListData()
        
    }
    
    @IBAction func toggleVideoType(_ sender: Any) {
        if(videoTypeSwitch.isOn){
                videoTypeLabel.text="Live"
                videoQuery = "videoType=Live&liveStreamStatus=Live&orderBy=liveStreamStartedAt"
            
        }
        else{videoTypeLabel.text="VOD"
                videoQuery = "videoType=VOD&orderBy=liveStreamStartedAt&liveStreamStatus=Finished"
        }
        getListData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int )-> Int{
        if(videos.count==0){tableView.setEmptyMessage("No one is broadcasting right now")}
        else{tableView.restore()}
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

    
    func getListData(){
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getListData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getListData()
    }
    }
    


