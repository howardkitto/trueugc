//
//  NewVideoViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 15/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit


class NewVideoViewController: UIViewController {
    
    @IBOutlet weak var titleTextBox: UITextField!
    
    @IBOutlet weak var validationMessage: UILabel!
    
    var userEnteredData = Video()
    var returnedData = Video()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BroadcastViewController{
            destination.newVideo = returnedData
        }
    }

    func submitNewVideo(videoTitle: String, completion:((Error?) -> Void)?) {
        
        self.userEnteredData.title = videoTitle
        self.userEnteredData.videoType = "Live"
        self.userEnteredData.status = "Live"
        
        
        var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.overloop.io"
            urlComponents.path = "/org/true/videos"
            urlComponents.query = "apiKey=sdf04jf904jcosmnghqa"
            guard let url = urlComponents.url
            else { fatalError("Could not create URL from components") }

            print("ready to post\(videoTitle)")

        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(userEnteredData)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData{
                self.returnedData = try! JSONDecoder().decode(Video.self, from: data)
                print("that is it \(self.returnedData)")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "startBroadcast", sender: self)
                    }
            }
        }
        task.resume()
    }

    @IBAction func postNewVideo(_ sender: Any) {
        
        let newVideoTitle : String? = titleTextBox.text
        if (newVideoTitle?.isEmpty)!
        {validationMessage.text="Enter a Title"}
        else {
            submitNewVideo(videoTitle : newVideoTitle!) { (error) in
                if let error = error {
                    (print(error))
                }
            }
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
