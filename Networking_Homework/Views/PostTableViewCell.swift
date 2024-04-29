//
//  PostTableViewCell.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameTableViewCellLabel: UILabel!
    @IBOutlet weak var bodyTableViewCellLabel: UILabel!
    
    func setupTextPosts(title: String) {
        bodyTableViewCellLabel.text = title
    }
    
    func setupTextUsers(name: String) {
        nameTableViewCellLabel.text = name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

