//
//  CommentTableViewCell.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import UIKit

class CommentTableViewCell: UITableViewCell, IdentifiedCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    func configure(with comment: Comment) {
        nameLabel.text = comment.name
        commentLabel.text = comment.body
        idLabel.text = "ID: \(comment.id)"
    }
    
}
