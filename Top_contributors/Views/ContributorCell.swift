//
//  ContributorCell.swift
//  Top_contributors
//
//  Created by Leo on 4/23/19.
//  Copyright © 2019 Git. All rights reserved.
//

import UIKit
protocol ContributorCellDelegate {
    func didTapToMapBtn(contributor_name: String)
}

class ContributorCell: UITableViewCell {
    
    var delegate: ContributorCellDelegate?
    
    @IBOutlet weak var avartar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var commits: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didTapToMapBtn(_ sender: UIButton) {
        delegate?.didTapToMapBtn(contributor_name: name.text!)
    }
    
}
