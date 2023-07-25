//
//  CharacterDetailsViewController.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit

class CharacterDetailsViewController: UIViewController, Storyborded {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var originNameLabel: UILabel!
    @IBOutlet weak var originTypeLabel: UILabel!
    @IBOutlet weak var originDimensionLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationTypeLabel: UILabel!
    @IBOutlet weak var locationDimensionLabel: UILabel!
    
    var viewModel: CharacterViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.nameLabel.text = viewModel.name
        self.setStatusColor(by: viewModel.status.lowercased())
        self.statusLabel.text = viewModel.status
        self.characterImageView.sd_setImage(with: viewModel.imageUrl, placeholderImage: UIImage(named: Images.defaultImage))
        self.originNameLabel.text = viewModel.originName
        self.originTypeLabel.text = viewModel.originType
        self.originDimensionLabel.text = viewModel.originDimesion
        self.locationNameLabel.text = viewModel.locationName
        self.locationTypeLabel.text = viewModel.locationType
        self.locationDimensionLabel.text = viewModel.locationDimesion
    }
    
    private func setStatusColor(by status: String) {
        if (status == "dead") {
            self.statusLabel.textColor = .red
        } else if (status == "alive") {
            self.statusLabel.textColor = .green
        }
    }
}
