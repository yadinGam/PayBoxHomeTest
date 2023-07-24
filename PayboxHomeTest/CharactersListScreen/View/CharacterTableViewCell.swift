//
//  CharacterTableViewCell.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit
import SDWebImage

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
    
    func configure(with viewModel: RMCharacterCellViewModelProtocol) {
        self.nameLabel.text = viewModel.name
        self.statusLabel.text = viewModel.name
        self.characterImageView.sd_setImage(with: viewModel.imageUrl, placeholderImage: UIImage(named: "placeholder.png"))
    }
}
