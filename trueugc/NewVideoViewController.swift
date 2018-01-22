//
//  NewVideoViewController.swift
//  trueugc
//
//  Created by Howard Kitto on 15/12/2017.
//  Copyright © 2017 Howard Kitto. All rights reserved.
//

import UIKit
import LFLiveKit

class NewVideoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //set up all the vars
    
    @IBOutlet weak var titleTextBox: UITextField!
    
    @IBOutlet weak var validationMessage: UILabel!
    
    @IBOutlet weak var qualityTextBox: UITextField!
    
    @IBOutlet weak var qualityPicker: UIPickerView!
    
    var userEnteredData = Video()
    var returnedData = Video()
    var newVideoSettings = VideoSettings()
    let now = Date()
    var timeStamp = String()
   
    var encodeSettings: [(qualityLabel : String, qualitySetting: LFLiveVideoQuality)] =
        [   ("Low1", LFLiveVideoQuality.low1),
            ("Low2", LFLiveVideoQuality.low2),
            ("Low3", LFLiveVideoQuality.low3),
            ("Medium 1", LFLiveVideoQuality.medium1),
            ("Medium 2", LFLiveVideoQuality.medium2),
            ("Medium 3", LFLiveVideoQuality.medium3),
            ("High 1", LFLiveVideoQuality.high1),
            ("High 2", LFLiveVideoQuality.high2),
            ("High 3", LFLiveVideoQuality.high3)]
    
    //video setttings controls
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return encodeSettings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return encodeSettings[row].qualityLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                newVideoSettings.qualityLabel = encodeSettings[row].qualityLabel
                newVideoSettings.qualitySetting = encodeSettings[row].qualitySetting
            }
    //Transmuxer controls
    
    @IBOutlet weak var tmxSegCtrl: UISegmentedControl!
    
    @IBAction func switchTmx(_ sender: Any) {
        
        switch tmxSegCtrl.selectedSegmentIndex {
        case 0:
            newVideoSettings.tmxServer = "54.84.196.102"
        case 1:
            newVideoSettings.tmxServer = "34.212.12.131"
        case 2:
            newVideoSettings.tmxServer = "54.169.88.136"
        default:
            break
        }
    }

    
    //Overloop integration
    
    func submitNewVideo(videoTitle: String, completion:((Error?) -> Void)?) {
        
        self.userEnteredData.title = videoTitle
        self.userEnteredData.videoType = "Live"
        self.userEnteredData.status = "Live"
        
        self.userEnteredData.liveStreamStartedAt = DateFormatter().string(from: now)
        
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
    
  //Post data to overloop

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
    
    //Move on to broadcast screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BroadcastViewController{
            destination.newVideo = returnedData
            print("videoQuality Label\(String(describing: newVideoSettings.qualityLabel))")
            destination.videoSettings = newVideoSettings
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qualityPicker.delegate = self
        self.qualityPicker.dataSource = self
        
        //default video settings (low quality and California)
        
        newVideoSettings.qualityLabel = "Low1"
        newVideoSettings.qualitySetting = LFLiveVideoQuality.low1
        newVideoSettings.tmxServer = "54.84.196.102"
        
        qualityPicker.selectRow(0, inComponent: 0, animated: false)
        
        
    }
    

}
