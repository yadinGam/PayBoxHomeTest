//
//  ViewController.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit
import RxSwift
import RxCocoa

class CharactersListViewController: UIViewController, Alertable {

    @IBOutlet weak var charactersTableView: UITableView!
    
    private var indicatorView = UIActivityIndicatorView()
    private var characters: [RMCharacter]?
    private var viewModel: CharactersViewModelProtocol?
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CharactersViewModel()
        bindIndicatorView()
        setupTableView()
        viewModel?.fetchCharacters()
    }
    
    private func setupTableView() {
        charactersTableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: CharacterTableViewCell.self))
        charactersTableView.rowHeight = UITableView.automaticDimension
        charactersTableView.estimatedRowHeight = 100
        charactersTableView.tableFooterView = UIView()
        
        self.bindTableViewData()
    }
    
    private func bindIndicatorView() {
        viewModel?.loadingBehavior.subscribe(onNext: { [weak self] isLoading in
            if (isLoading){
                self?.addActivityIndicator()
            } else {
                self?.removeIndicatorView()
            }
        }).disposed(by: bag)
    }
    
    private func bindTableViewData() {
        viewModel?.charactersViewModels.bind(to: charactersTableView.rx.items(cellIdentifier: String(describing: CharacterTableViewCell.self), cellType: CharacterTableViewCell.self)) {
            row, item, cell in
            cell.configure(with: CharacterCellViewModel(character: item))
        }.disposed(by: bag)
        
//        charactersTableView.rx.modelSelected(RMCharacter.self).bind { [weak self] model in
//            let detailsViewModel = CharacterViewModel(with: model)
//            //TODO: move to next screen
//            print(detailsViewModel)
//        }.disposed(by: bag)
        
        charactersTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                let detailsViewModel = self.viewModel?.charactersViewModels.value[indexPath.row]
                // TODO: make a service call to bring the location for the specific character and move to the next screen using 'detailsViewModel'
                print("Selected Model: \(String(describing: detailsViewModel))")
                
     
                self.charactersTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: bag)
    }

}

extension CharactersListViewController {
    
    func addActivityIndicator() {
        self.view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        let xConstraint = NSLayoutConstraint(item: self.indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)

        let yConstraint = NSLayoutConstraint(item: self.indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([xConstraint, yConstraint])
        
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func removeIndicatorView() {
        self.indicatorView.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
}
