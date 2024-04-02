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
    
    func setupTextPosts(title: String) {
//        loadTableViewCellLabel.text = userId
//        nameTableViewCellLabel.text = id
        statusTableViewCellLabel.text = title
//        bodyTableViewCellLabel.text = body
    }
    
    func setupTextUsers(name: String) {
//        loadTableViewCellLabel.text = Id
        nameTableViewCellLabel.text = name
//        statusTableViewCellLabel.text = username
//        bodyTableViewCellLabel.text = email
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

