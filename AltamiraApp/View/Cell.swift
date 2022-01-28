//
//  Cell.swift
//  AltamiraApp
//
//  Created by Ceren Çapar on 25.01.2022.
//

import UIKit

class Cell: UITableViewCell {
    @IBOutlet weak var nameLabelField: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
