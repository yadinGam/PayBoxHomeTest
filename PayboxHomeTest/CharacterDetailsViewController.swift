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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = "השם של הדמות"
    }
    
    
  

}
