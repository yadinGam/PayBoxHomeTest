//
//  CharacterDetailsViewController.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var originNameLabel: UILabel!
    @IBOutlet weak var originTypeLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTypeLabel: UILabel!
    
    private var viewModel: CharacterViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.nameLabel.text = viewModel.name
        self.statusLabel.text = viewModel.status
        self.characterImageView.sd_setImage(with: viewModel.imageUrl, placeholderImage: UIImage(named: "placeholder.png"))
        self.originNameLabel.text = viewModel.name
        self.originTypeLabel.text = viewModel.name
        self.locationNameLabel.text = viewModel.name
        self.locationTypeLabel.text = viewModel.name
    }
}
