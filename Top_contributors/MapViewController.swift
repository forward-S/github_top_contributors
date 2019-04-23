//
//  MapViewController.swift
//  Top_contributors
//
//  Created by Leo on 4/23/19.
//  Copyright © 2019 Git. All rights reserved.
//

import UIKit
import Alamofire

class MapViewController: UIViewController {
    var contributor_name: String!
    var location: String!
    
    @IBOutlet weak var contributorNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contributorNameLabel.text = "\(contributor_name as String)"
        Alamofire.request("https://api.github.com/users/\(contributor_name as String)").responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                if let converted_result = self.convertToDictionary(text: utf8Text) as? Dictionary<String, Any> {
                    print("\(converted_result)")
                    if let temp_location = converted_result["location"] {
                        self.location = "\(temp_location)"
                        self.locationLabel.text = self.location
                    }
                }
            }
        }
    }
    
    func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func closeMap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
