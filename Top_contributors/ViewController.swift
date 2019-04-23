//
//  ViewController.swift
//  Top_contributors
//
//  Created by Leo on 4/23/19.
//  Copyright © 2019 Git. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var top_contributors = [AnyObject]()
    var selected_contributor_name: String!
    
    @IBOutlet weak var contributor_table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Alamofire.request("https://api.github.com/repos/ruby/ruby/contributors").responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                if let converted_result = self.convertToDictionary(text: utf8Text) as? [AnyObject] {
                    self.top_contributors = converted_result
                    self.contributor_table.dataSource = self
                    self.contributor_table.delegate = self
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? MapViewController {
            destinationVC.contributor_name = selected_contributor_name            
        }
    }
}

extension ViewController: ContributorCellDelegate {
    func didTapToMapBtn(contributor_name: String) {
        selected_contributor_name = contributor_name
//        // Let's assume that the segue name is called mapSegue
//        // This will perform the segue and pre-load the variable for you to use
        performSegue(withIdentifier: "mapSegue", sender: self)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return top_contributors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContributorCell", for: indexPath) as! ContributorCell
        
        cell.tag = indexPath.row
        cell.delegate = self
        
        let contributor = top_contributors[(indexPath as NSIndexPath).row]
        if let url = URL(string: "\(contributor["avatar_url"] as! String)")
        {
            DispatchQueue.global().async {
                if let data = try? Data( contentsOf:url)
                {
                    DispatchQueue.main.async {
                        cell.avartar.image = UIImage( data:data)
                    }
                }
            }
        }
        cell.name.text = "\(contributor["login"] as! String)"
        cell.commits.text = "\(contributor["contributions"] as! Int)"
        return cell
    }
}

