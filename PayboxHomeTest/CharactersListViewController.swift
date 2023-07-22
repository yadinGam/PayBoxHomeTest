//
//  ViewController.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit

class CharactersListViewController: UIViewController {

    @IBOutlet weak var charactersTableView: UITableView!
    
    private var characters: [String] = ["Yadin","Lior","Eden","Meitar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }

    private func setupTableView() {
        self.charactersTableView.delegate = self
        self.charactersTableView.dataSource = self
        
        charactersTableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: CharacterTableViewCell.self))
        charactersTableView.rowHeight = UITableView.automaticDimension
        charactersTableView.estimatedRowHeight = 100
        charactersTableView.tableFooterView = UIView()
    }

}

extension CharactersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else {
            return
        }
        
        print("selected characters named: \(self.characters[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CharactersListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharacterTableViewCell.self)) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.configure(name: self.characters[indexPath.row])
        return cell
    }
    
}

