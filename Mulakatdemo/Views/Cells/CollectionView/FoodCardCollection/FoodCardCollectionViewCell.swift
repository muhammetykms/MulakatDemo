//
//  FoodCardCollectionViewCell.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 3.11.2024.
//

import UIKit

class FoodCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelContentFood: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    @IBOutlet weak var labelLocationFood: UILabel!
    @IBOutlet weak var foodTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("FoodCardCollectionViewCell yüklendi")
        self.contentView.layer.cornerRadius = 30
           self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.systemGray6.cgColor
        self.imageViewFood.layer.cornerRadius = 30

    }

}
