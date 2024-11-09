//
//  CommentCollectionViewCell.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 9.11.2024.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var allTheCommentButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        commentTextView.isEditable = false
        //allTheCommentButton.layer.cornerRadius = 10
        //allTheCommentButton.layer.borderColor = UIColor.orange.cgColor
        //allTheCommentButton.layer.borderWidth = 1
    }
    
    func configure(with comment: Comment) {
            profileImageView.image = UIImage(named: comment.profileImage)
            userNameLabel.text = comment.userName
        commentTextView.text = comment.comment
            dateLabel.text = comment.date
        //likeLabel.setTitle("\(comment.likes) Beğenme", for: .normal)
        }

}
