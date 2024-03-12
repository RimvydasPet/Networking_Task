//
//  PostTableViewCell.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loadTableViewCellLabel: UILabel!
    @IBOutlet weak var nameTableViewCellLabel: UILabel!
    @IBOutlet weak var statusTableViewCellLabel: UILabel!
    @IBOutlet weak var bodyTableViewCellLabel: UILabel!
    
    func setupText(userId: String, id: String, title: String, body: String) {
        loadTableViewCellLabel.text = userId
        nameTableViewCellLabel.text = id
        statusTableViewCellLabel.text = title
        bodyTableViewCellLabel.text = body
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

