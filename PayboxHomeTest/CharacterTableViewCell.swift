//
//  CharacterTableViewCell.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(name: String) {
        self.nameLabel.text = name
        self.statusLabel.text = "this is the status"
    }
    
}
