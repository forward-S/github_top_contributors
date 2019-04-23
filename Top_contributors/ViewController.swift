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
    var top_contributers = [AnyObject]()
    @IBOutlet weak var contributer_table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Alamofire.request("https://api.github.com/repos/ruby/ruby/contributors").responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                if let converted_result = self.convertToDictionary(text: utf8Text) as? [AnyObject] {
                    self.top_contributers = converted_result
                    self.contributer_table.dataSource = self
                    self.contributer_table.delegate = self
                    print("top_contributers: \(self.top_contributers)")
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
}

//extension HomeViewController: UserCellDelegate {
//    func didTapToMapBtn() {
//
//    }
//}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return top_contributers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        cell.tag = indexPath.row
//        cell.delegate = self
        
        let contributor = top_contributers[(indexPath as NSIndexPath).row]
        cell.avartar.image = UIImage(named: (contributor["avatar_url"])! as! String)
        cell.user_name.text = "\(contributor["login"] as! String)"
        cell.commits.text = "\(contributor["contributions"] as! Int)"
        return cell
    }
}

